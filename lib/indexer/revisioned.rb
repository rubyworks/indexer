module Indexer

  module Revisioned

    #
    # Revision factory returns a versioned instance of the model class.
    #
    # @param [Hash] data
    #   The data to populate the instance.
    #
    def new(data={})
      revision, data = revised(data)
      basename = name.split('::').last
      V[revision].const_get(basename).new(data)
    end

    #
    # Revision factory returns a validated versioned instance of the model class.
    #
    # @param [Hash] data
    #   The data to populate the instance.
    #
    def valid(data)
      revision, data = revised(data)
      basename = name.split('::').last
      V[revision].const_get(basename).valid(data)
    end

  private

    #
    #
    #
    def revised(data)
      revision = data['revision'] || data[:revision]

      unless revision
        # TODO: raise error instead ?
        revison          = REVISION
        data['revision'] = REVISION
      end

      return revision, data
    end

  end

end
