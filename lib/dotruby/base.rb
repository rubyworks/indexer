module DotRuby

  # Base class for Validator and Spec classes.
  class Base
    include HashLike

    ## Default file name of `.ruby` file. It is obviously `.ruby` ;-)
    #FILE_NAME = '.ruby'

    # DotRuby uses a strict revision system.
    attr :revision

    # Set the revision.
    def revision=(value)
      @revision = value.to_i
    end

    # New instance.
    #
    # @param [Hash] data
    #   The metadata to populate the instance.
    #
    def initialize(data={})
      initialize_attributes

      merge!(data)
    end

    private

    #
    def validate(value, field, *types)
      types.each do |type|
        Valid.send(type, value, field)
      end
      return value
    end

  end

end
