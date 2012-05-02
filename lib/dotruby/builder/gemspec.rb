module DotRuby

  class Builder

    # It is not the recommended that a .gemspec be the usual source of a .ruby
    # spec. Rather it is highly recommended that a the gemspec be produced from
    # the .ruby instead. Nonetheless, this can serve as a temporary measure
    # for creating a .ruby file until the .ruby is used as the primary metadata
    # file.
    #
    module GemspecBuild
      #
      # If the source file is a gemspec, import it.
      #
      def build(source)
        case File.extname(source)
        when '.gemspec'
          # TODO: handle YAML-based gemspecs
          gemspec = ::Gem::Specification.load(source)
          spec.import_gemspec(gemspec)
          true
        else
          super(source) if defined?(super)
        end
      end

      #
      #def local_files(root, glob, *flags)
      #  bits = flags.map{ |f| File.const_get("FNM_#{f.to_s.upcase}") }
      #  files = Dir.glob(File.join(root,glob), bits)
      #  files = files.map{ |f| f.sub(root,'') }
      #  files
      #end
    end

    # Include GemspecBuild mixin into Builder class.
    include GemspecBuild

  end

end

