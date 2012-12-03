module Indexer

  class Importer

    # Import metadata from a YAML source.
    #
    module YAMLImportation

      #
      # YAML import procedure.
      #
      def import(source)
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
      # Import metadata from YAML file.
      #
      def load_yaml(file)
        metadata.merge!(YAML.load_file(file))
      end

    end

    # Include YAMLImportation mixin into Builder class.
    include YAMLImportation

  end

end
