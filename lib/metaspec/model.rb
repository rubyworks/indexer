module Meta

  class Model

    # What the heck does this do?
    #
    #   author = Meta::V0::Author.new(...)
    #   author.is_a?(Meta::Author)  #=> true
    #
    # TODO: This is probably a dead giveaway that the inverse factory
    #       we are using via module extensions, is not the way to go.
    #
    def self.inherited(base)
      basename = base.name.split('::').last
      if not Meta.const_defined?(basename)
        mod = Module.new
        mod.module_eval %{
          # Use constant hash instead?
          def self.V(revision)
            Meta::V[revison]::#{basename}
          end
          def self.new(*args, &blk)
            Meta::V[CURRENT_REVISION]::#{basename}.new(*args, &blk)
          end
        }
        Meta.const_set(basename, mod)
      else
        mod = Meta.const_get(basename)
      end
      base.send(:include, mod)
    end

  end

end
