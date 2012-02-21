module DotRuby

  # Build external sources into .ruby specification.
  #
  def self.build(*sources)
    Builder.build(*sources)
  end

  # Builder class takes disperate data sources and imports them
  # into the .ruby specification.
  #
  # Mixins are used to inject build behavior by overriding the `#build` method.
  # Any such  mixin's #build method must call `#super` if it's method doesn't
  # apply, allowing the routine to fallback the other possible build methods.
  #
  class Builder

    # Require all builder mixins.
    def self.require_builders
      if RUBY_VERSION < '1.9'
        require 'dotruby/builder/file'
        require 'dotruby/builder/ruby'
        require 'dotruby/builder/yaml'
        require 'dotruby/builder/gemspec'
        require 'dotruby/builder/gemfile'
      else
        require_relative 'builder/file'
        require_relative 'builder/ruby'
        require_relative 'builder/yaml'
        require_relative 'builder/gemspec'
        require_relative 'builder/gemfile'
      end
    end

    #
    # Build .ruby specification from external sources.
    #
    def self.build(*source)
      require_builders

      spec = nil

      if Spec.exists?
        spec   = Spec.find
        source = spec.source if source.empty?
      end

      builder = Builder.new(spec)

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
      super(source) if defined?(super)
      spec.source << source unless spec.source.include?(source)
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
      if a.empty?
        if @spec.respond_to?(s)
          @spec.__send__(s)
        else
          super(s, *a, &b)
        end
      else
        x = s.to_s.chomp('=')
        if @spec.respond_to?("#{x}=")
          @spec.__send__("#{x}=", *a, &b)
        else
          super(s, *a, &b)
        end
      end
    end

  end

end
