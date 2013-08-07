module Indexer

  # Import external sources into metadata.
  #
  def self.import(*sources)
    Importer.import(*sources)
  end

  # Importer class takes disperate data sources and imports them
  # into a Metadata instance.
  #
  # Mixins are used to inject import behavior by overriding the `#import` method.
  # Any such  mixin's #import method must call `#super` if it's method doesn't
  # apply, allowing the routine to fallback the other possible import methods.
  #
  class Importer

    #
    # Require all import mixins.
    #
    # This method calls `super` if it is defined which makes it easy
    # for plugins to add new importers.
    #
    def self.require_importers
      require_relative 'importer/file'
      require_relative 'importer/ruby'
      require_relative 'importer/yaml'
      require_relative 'importer/html'
      require_relative 'importer/markdown'
      #require_relative 'importer/rdoc'
      #require_relative 'importer/textile'
      require_relative 'importer/gemspec'
      require_relative 'importer/gemfile'
      require_relative 'importer/version'

      # for plugins to easily add additional importers
      super if defined?(super)
    end

    #
    # Import metadata from external sources.
    #
    def self.import(*source)
      options = (Hash === source.last ? source.pop : {})

      require_importers

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

      importer = Importer.new #(metadata)

      source.each do |src|
        importer.import(src)
      end

      return importer.metadata
    end

    #
    # Initialize importer.
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
    def import(source)
      success = super(source) if defined?(super)
      if success
        metadata.sources << source unless metadata.sources.include?(source)
      else
        raise "metadata source not found or not a known type -- #{source}"
      end
    end

    #
    # Provides a file contents cache. This is used by the YAMLImportation
    # script, for instance, to see if the file begins with `---`, in
    # which case the file is taken to be YAML format, even if the 
    # file's extension is not `.yml` or `.yaml`.
    #
    def read(file)
      @file_cache[file] ||= File.read(file)
    end

    #
    # Evaluating on the Importer instance, allows Ruby basic metadata
    # to be built via this method.
    #
    def method_missing(s, *a, &b)
      return if s == :import

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
