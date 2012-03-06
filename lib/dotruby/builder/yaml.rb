module DotRuby

  class Builder

    # Build .ruby spec from a YAML source.
    #
    module YAMLBuild

      #
      # YAML build procedure.
      #
      def build(source)
        return super(source) unless File.file?(source)

        case File.extname(source)
        when '.yaml', '.yml'
          load_yaml(source)
        else
          text = read(source)
          if text =~ /\A---/
            load_yaml(source)
          else
            super(source)
          end
        end
      end

      #
      # Import spec settings from YAML file.
      #
      def load_yaml(file)
        spec.merge!(YAML.load_file(file))
      end

    end

    # Include YAMLBuild mixin into Builder class.
    include YAMLBuild

  end

end
