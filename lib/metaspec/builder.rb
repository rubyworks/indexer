module Meta

  # Build external sources into rubgy meta specification.
  #
  def self.build(*sources)
    Builder.build(*sources)
  end

  # Builder class takes disperate data sources and imports them
  # into the .meta specification.
  #
  # Mixins are used to inject build behavior by overriding the `#build` method.
  # Any such  mixin's #build method must call `#super` if it's method doesn't
  # apply, allowing the routine to fallback the other possible build methods.
  #
  class Builder

    # Require all builder mixins.
    def self.require_builders
      if RUBY_VERSION < '1.9'
        require 'metaspec/builder/file'
        require 'metaspec/builder/ruby'
        require 'metaspec/builder/yaml'
        require 'metaspec/builder/gemspec'
        require 'metaspec/builder/gemfile'
        require 'metaspec/builder/version'
      else
        require_relative 'builder/file'
        require_relative 'builder/ruby'
        require_relative 'builder/yaml'
        require_relative 'builder/gemspec'
        require_relative 'builder/gemfile'
        require_relative 'builder/version'
      end
    end

    #
    # Build meta specification from external sources.
    #
    def self.build(*source)
      options = (Hash === source.last ? source.pop : {})

      require_builders

      #spec = nil

      ## use source of current spec if none given
      ## TODO: Only search the current direcory or search up to root?
      if source.empty? 
        if file = Dir['.meta'].first  #or `Spec.exists?` ?
          data = YAML.load_file(file)
          source = Array(data['source'])
        end
      end

      raise ArgumentError, "no data sources" if source.empty?

      builder = Builder.new #(spec)

      source.each do |src|
        builder.build(src)
      end

      return builder.spec
    end

    #
    #
    #
    def initialize(spec=nil)
      @spec = spec || Spec.new
      @file_cache = {}
    end

    #
    # Specification being built.
    #
    attr :spec

    #
    #
    #
    def build(source)
      success = super(source) if defined?(super)
      if success
        spec.source << source unless spec.source.include?(source)
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
    # Evaluating on the Builder instance, allows Ruby basic specs
    # to be built via this method.
    #
    def method_missing(s, *a, &b)
      return if s == :build

      r = s.to_s.chomp('=')
      case a.size
      when 0
        if @spec.respond_to?(s)
          return @spec.__send__(s, &b)
        end
      when 1
        if @spec.respond_to?("#{r}=")
          return @spec.__send__("#{r}=", *a)
        end
      else
        if @spec.respond_to?("#{r}=")
          return @spec.__send__("#{r}=", a)
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
      text =~ /\A---/
    end
  end

end
