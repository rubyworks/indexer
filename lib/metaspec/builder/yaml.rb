module Meta

  class Builder

    # Build metaspec from a YAML source.
    #
    module YAMLBuild

      #
      # YAML build procedure.
      #
      def build(source)
        if File.file?(source)
          case File.extname(source)
          when '.yaml', '.yml'
            load_yaml(source)
            true
          else
            text = read(source)
            if text =~ /\A---/
              load_yaml(source)
              true
            else
              super(source) if defined?(super)
            end
          end
        else
          super(source) if defined?(super)
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
