module Indexer

  #
  # Main model that ties in all the other models.
  #
  module Metadata
    extend Revisioned
    extend Loadable

    #
    # Set the revision. This attribute, by definition, must be outside of the
    # revisioned definition of Metadata.
    #
    def revision=(value)
      @data['revision'] = value.to_i
    end
  end

  module Author
    extend Revisioned
  end

  module Company
    extend Revisioned
  end

  module Conflict
    extend Revisioned
  end

  module Copyright
    extend Revisioned
  end

  module Resource
    extend Revisioned
  end

  module Repository
    extend Revisioned
  end

  module Requirement
    extend Revisioned
  end

  module Dependency
    extend Revisioned
  end

end
