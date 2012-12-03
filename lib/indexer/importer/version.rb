module Indexer

  class Importer

    # Build mixin for Bundler's Gemfile.
    #
    module VersionImportation
      #
      # If the source file is a Gemfile, import it.
      #
      def import(source)
        case source
        when 'VERSION.txt', 'Version.txt'
          vers = File.read(source).strip
          metadata.version = vers
        when 'VERSION', 'Version'
          text = File.read(source).strip
          if yaml?(text)
            # don't really like this style b/c it's too subjective
            hash = YAML.load(text)
            hash = hash.inject{ |h,(k,v)| h[k.to_sym] = v; h }
            vers = hash.values_at(:major,:minor,:patch,:build).compact
          else
            vers = File.read(source).strip
          end
          metadata.version = vers
        else
          super(source) if defined?(super)
        end
      end
    end

    # Include VersionImportation mixin into Builder class.
    include VersionImportation

  end

end
