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
          def self.new(*args, &blk)
            V[CURRENT_REVISION]::#{basename}.new(*args, &blk)
          end
        }
        DotRuby.const_set(basename, mod)
      else
        c = DotRuby::const_get(basename)
        # if version is greater than presently defined
      end
    end

  end

end
