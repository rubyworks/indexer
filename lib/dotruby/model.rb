module DotRuby

  class Model

    # What the heck does this do?
    #
    #   author = DotRuby::V0::Author.new(...)
    #   author.is_a?(DotRuby::Author)  #=> true
    #
    def self.inherited(base)
      basename = base.name.split('::').last
      if not DotRuby.const_defined?(basename)
        mod = Module.new
        mod.module_eval %{
          # Use constant hash instead?
          def self.V(revision)
            DotRuby::V[revison]::#{basename}
          end
          def self.new(*args, &blk)
            DotRuby::V[CURRENT_REVISION]::#{basename}.new(*args, &blk)
          end
        }
        DotRuby.const_set(basename, mod)
      else
        mod = DotRuby.const_get(basename)
      end
      base.send(:include, mod)
    end

  end

end
