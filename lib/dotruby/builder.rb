module DotRuby

  # Autobuild .ruby specification.
  def self.autobuild(*source)
    spec = nil

    if Spec.exists?
      spec   = Spec.find
      source = spec.source if source.empty?
    end

    builder = Builder.new

    source.each do |src|
      builder.autobuild(src)
    end

    if $USE_STDOUT  # TODO: Yea, we shouldn't use a global.
      puts builder.spec.to_yaml
    else
      if spec
        # FIXME: only save if different, equality currently does not work
        builder.spec.save! if spec != builder.spec
      else
        builder.spec.save!
      end
    end
  end

  # Builder class takes disperate data sources and imports them
  # into the .ruby specification.
  #
  class Builder

    # Specification being built.
    attr :spec

    #
    def initialize(spec=nil)
      @spec = spec || Spec.new
    end

    #
    def autobuild(source)
      super(source) if defined?(super)
    end

    # Standard Building module. Plug-ins can override the `#autobuild` method
    # by including a new module into Builder. The plug-in's autobuild method
    # should call `super`, if it's method doesn't apply, allowing the routine
    # to fallback the the standard autobuild.
    module Standard

      # Standard autobuild procedure.
      def autobuild(source)
        if File.directory?(source)
          load_directory(source)          
        else
          load_file(source)
        end
        @spec.source << source unless @spec.source.include?(source)
      end

      #
      def load_file(file)
        case File.extname(file)
        when '.yaml', '.yml'
          load_yaml(file)
        when '.rb'
          load_ruby(file)
        else
          begin
            text = File.read(file)
            if text =~ /\A---/
              load_yaml(file)
            else
              load_ruby(file)
            end
          rescue
            raise "ERROR: Could not read source -- `#{source}'."
          end
        end
      end

      # Import setting(s) from another file.
      def load_yaml(file)
        @spec.merge!(YAML.load_file(file))
      end

      #
      def load_ruby(file)
        instance_eval(File.read(file))
      end

      # Import files in a given directory. This will only import files
      # that have a name corresponding to a DotRuby attributes, unless
      # the file is listed in a `.rubyextra` file within the directory.
      #
      # However, files with an extension of `.yml` or `.yaml` will be loaded
      # wholeclothe and not as a single attribute.
      #
      # TODO: Subdirectories are simply omitted. Maybe do otherwise in future?
      def load_directory(folder)
        if File.directory?(folder)
          extra = []
          extra_file = File.join(folder, '.rubyextra')
          if File.exist?(extra_file)
            extra = File.read(extra_file).split("\n")
            extra = extra.collect{ |pattern| pattern.strip  }
            extra = extra.reject { |pattern| pattern.empty? }
            extra = extra.collect{ |pattern| Dir[File.join(folder, pattern)] }.flatten
          end
          files = Dir[File.join(folder, '*')]
          files.each do |file|
            next if File.directory?(file)
            name = File.basename(file)
            next load_yaml(file) if %w{.yaml .yml}.include?(File.extname(file))
            next load_field_file(file) if extra.include?(name)
            next load_field_file(file) if @spec.attributes.include?(name.to_sym)
          end
        end
      end

      # Import a field setting from a file.
      def load_field_file(file)
        if File.directory?(file)
          # ...
        else
          case File.extname(file)
          when '.yaml', '.yml'
            name = File.basename(file).chomp('.yaml').chomp('.yml')
            @spec[name] = YAML.load_file(file)
            #@spec.merge!(YAML.load_file(file))
          else
            text = File.read(file)
            if /\A---/ =~ text
              name = File.basename(file)
              @spec[name] = YAML.load(text)
            else
              name = File.basename(file)
              @spec[name] = text.strip
            end
          end
        end
      end

    end

    include Standard

    # Evaluating on the Builder instance, allows Ruby basic specs
    # to be built via this method.
    def method_missing(s, *a, &b)
      x = s.to_s.chomp('=')
      if @spec.respond_to?("#{x}=")
        @spec.__send__("#{x}=", *a, &b)
      else
        super(s, *a, &b)
      end
    end

  end

end
