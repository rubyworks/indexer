module Rumbler

  # Build external sources into metadata.
  #
  def self.build(*sources)
    Builder.build(*sources)
  end

  # Builder class takes disperate data sources and imports them
  # into a Metadata instance.
  #
  # Mixins are used to inject build behavior by overriding the `#build` method.
  # Any such  mixin's #build method must call `#super` if it's method doesn't
  # apply, allowing the routine to fallback the other possible build methods.
  #
  class Builder

    # Require all builder mixins.
    def self.require_builders
      require_relative 'builder/file'
      require_relative 'builder/ruby'
      require_relative 'builder/yaml'
      require_relative 'builder/gemspec'
      require_relative 'builder/gemfile'
      require_relative 'builder/version'
    end

    #
    # Build metadata from external sources.
    #
    def self.build(*source)
      options = (Hash === source.last ? source.pop : {})

      require_builders

      #metadata = nil

      ## use source of current metadata if none given
      ## TODO: Only search the current directory or search up to root?
      if source.empty? 
        if file = Dir[LOCK_FILE].first  #or `Metadata.exists?` ?
          data   = YAML.load_file(file)
          source = Array(data['source'])
        end
      end

      if source.empty?
        source = [USER_FILE]
      end

      source.each do |file|
        unless File.exist?(file)
          warn "metadata source file not found - `#{file}'"
        end
      end

      builder = Builder.new #(metadata)

      source.each do |src|
        builder.build(src)
      end

      return builder.metadata
    end

    #
    # Initialize builder.
    #
    def initialize(metadata=nil)
      @metadata   = metadata || Metadata.new
      @file_cache = {}
    end

    #
    # Metadata being built.
    #
    attr :metadata

    #
    #
    #
    def build(source)
      success = super(source) if defined?(super)
      if success
        metadata.source << source unless metadata.source.include?(source)
      else
        raise "metadata source not found or not a known type -- #{source}"
      end
    end

    #
    # Provides a file contents cache. This is used by the YAMLBuild
    # script, for instance, to see if the file begins with `---`, in
    # which case the file is taken to be YAML format, even if the 
    # file's extension is not `.yml` or `.yaml`.
    #
    def read(file)
      @file_cache[file] ||= File.read(file)
    end

    #
    # Evaluating on the Builder instance, allows Ruby basic metadata
    # to be built via this method.
    #
    def method_missing(s, *a, &b)
      return if s == :build

      r = s.to_s.chomp('=')
      case a.size
      when 0
        if metadata.respond_to?(s)
          return metadata.__send__(s, &b)
        end
      when 1
        if metadata.respond_to?("#{r}=")
          return metadata.__send__("#{r}=", *a)
        end
      else
        if metadata.respond_to?("#{r}=")
          return metadata.__send__("#{r}=", a)
        end
      end

      super(s, *a, &b)  # if cases don't match-up
    end

    #
    # Is `text` a YAML document? It detrmines this simply
    # be checking for `---` at the top of the text.
    #
    # @todo Ignore top comments.
    #
    def yaml?(text)
      text =~ /\A(---|%TAG|%YAML)/
    end
  end

end
