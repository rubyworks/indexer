module DotRuby

  class Builder

    # Build .ruby spec from a Ruby script.
    #
    module RubyBuild

      #
      # Ruby script build procedure.
      #
      def build(source)
        return super(source) unless File.file?(source)

        case File.extname(source) 
        when '.rb'  # TODO: Other ruby extensions ?
          load_ruby(source)
        else
          if text !=~ /\A---/  # not YAML
            load_ruby(source)
          else
            super(source)
          end         
        end
      end

      #
      # Load ruby file by simply evaluating it in the context
      # of the Builder instance.
      #
      def load_ruby(file)
        instance_eval(File.read(file))
      end

    end #module RubyBuild

    # Include RubyBuild mixin into Builder class.
    include RubyBuild

  end

end
