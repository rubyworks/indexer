module Indexer

  class Builder

    # Build mixin for Bundler's Gemfile.
    #
    module GemfileBuild
      #
      # If the source file is a Gemfile, import it.
      #
      def build(source)
        case source
        when 'Gemfile'
          metadata.import_gemfile(source)
          true
        else
          super(source) if defined?(super)
        end
      end
    end

    # Include GemfileBuild mixin into Builder class.
    include GemfileBuild

  end

end
