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
        case File.extname(source)
        when '.yaml', '.yml'
          @spec.merge!(YAML.load_file(source))
        when '.rb'
          instance_eval(File.read(source))
        else
          begin
            text = File.read(source)      
            if text =~ /\A---/
              @spec.merge!(YAML.load_file(source))
            else
              instance_eval(File.read(source))
            end
          rescue
            raise "ERROR: Could not read source -- `#{source}'."
          end
        end
        @spec.source << source unless @spec.source.include?(source)
      end

    end

    include Standard

    # Evaluating on the Builder instance, allows Ruby basic specs
    # to be built via this method.
    def method_missing(field, *a, &b)
      field = field.to_s.chomp('=')
      @spec.__send__("#{field}=", *a, &b)
    end

  end

end
