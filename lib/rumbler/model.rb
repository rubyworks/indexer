module Rumbler

  class Model

    # What the heck does this do?
    #
    #   author = Rumbler::V0::Author.new(...)
    #   author.is_a?(Rumbler::Author)  #=> true
    #
    # TODO: This is probably a dead giveaway that the inverse factory
    #       we are using via module extensions, is not the way to go.
    #
    def self.inherited(base)
      basename = base.name.split('::').last
      if not Rumbler.const_defined?(basename)
        mod = Module.new
        mod.module_eval %{
          # Use constant hash instead?
          def self.V(revision)
            Rumbler::V[revison]::#{basename}
          end
          def self.new(*args, &blk)
            Rumbler::V[CURRENT_REVISION]::#{basename}.new(*args, &blk)
          end
        }
        Rumbler.const_set(basename, mod)
      else
        mod = Rumbler.const_get(basename)
      end
      base.send(:include, mod)
    end

  end

end
