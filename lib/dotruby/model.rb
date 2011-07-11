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
          def self.v(revision, *args, &blk)
            V[revison]::#{basename}.new(*args, &blk)
          end
          def self.new(*args, &blk)
            V[CURRENT_REVISION]::#{basename}.new(*args, &blk)
          end
        }
        DotRuby.const_set(basename, mod)
      else
        DotRuby.const_get(basename)
      end
    end

  end

end