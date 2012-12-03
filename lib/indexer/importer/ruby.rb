module Indexer

  class Importer

    # Build metadata from a Ruby script.
    #
    module RubyImportation

      #
      # Ruby script import procedure.
      #
      def import(source)
        if File.file?(source)
          case File.extname(source) 
          when '.rb'  # TODO: Other ruby extensions ?
            load_ruby(source)
            true
          else
            text = read(source)
            if text !=~ /\A---/  # not YAML
              load_ruby(source)
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
      # Load ruby file by simply evaluating it in the context
      # of the Builder instance.
      #
      def load_ruby(file)
        instance_eval(File.read(file))
      end

    end #module RubyImportation

    # Include RubyImportation mixin into Builder class.
    include RubyImportation

  end

end
