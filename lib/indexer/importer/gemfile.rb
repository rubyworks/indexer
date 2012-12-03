module Indexer

  class Importer

    # Build mixin for Bundler's Gemfile.
    #
    module GemfileImportation
      #
      # If the source file is a Gemfile, import it.
      #
      def import(source)
        case source
        when 'Gemfile'
          metadata.import_gemfile(source)
          true
        else
          super(source) if defined?(super)
        end
      end
    end

    # Include GemfileImportation mixin into Builder class.
    include GemfileImportation

  end

end
