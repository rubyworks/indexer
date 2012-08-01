module Meta

  class Builder

    # Build mixin for Bundler's Gemfile.
    #
    module VersionBuild
      #
      # If the source file is a Gemfile, import it.
      #
      def build(source)
        case source
        when 'VERSION.txt', 'Version.txt'
          vers = File.read(source).strip
          @spec.version = vers
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
          @spec.version = vers
        else
          super(source) if defined?(super)
        end
      end
    end

    # Include VersionBuild mixin into Builder class.
    include VersionBuild

  end

end
