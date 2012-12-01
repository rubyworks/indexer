module Indexer

  class Model

    # What the heck does this do?
    #
    #   author = Indexer::V0::Author.new(...)
    #   author.is_a?(Indexer::Author)  #=> true
    #
    # TODO: This is probably a dead giveaway that the inverse factory
    #       we are using via module extensions, is not the way to go.
    #
    def self.inherited(base)
      basename = base.name.split('::').last
      if not Indexer.const_defined?(basename)
        mod = Module.new
        mod.module_eval %{
          # Use constant hash instead?
          def self.V(revision)
            Indexer::V[revison]::#{basename}
          end
          def self.new(*args, &blk)
            Indexer::V[REVISION]::#{basename}.new(*args, &blk)
          end
        }
        Indexer.const_set(basename, mod)
      else
        mod = Indexer.const_get(basename)
      end
      base.send(:include, mod)
    end

  end

end
