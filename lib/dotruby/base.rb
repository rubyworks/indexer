module DotRuby

  # Base class for Data and Spec classes.
  class Base
    include HashLike

    # Default file name of `.ruby` file. It is obviously `.ruby` ;-)
    FILE_NAME = '.ruby'

    # DotRuby uses a strict revision system.
    attr :revision

    # Set the revision.
    def revision=(value)
      @revision = value.to_i
    end

    # New instance.
    def initialize(data={})
      self.revision = data.delete('revision') || data.delete(:revision) || CURRENT_REVISION

      initialize_model
      initialize_attributes

      merge!(data)
    end

    # Find project root by looking upward for a `.ruby` file.
    #
    # @param [String] from
    #   The directory from which to start the upward search.
    #
    # @return [String]
    #   The path to the `.ruby` file.
    #
    # @raise []
    #   The `.ruby` file could not be located.
    #
    def self.root(from=Dir.pwd)
      Dir.ascend(from) do |path|
        if File.file?(File.join(path,FILE_NAME))
          return path
        end
      end

      raise("could not locate the #{FILE_NAME} file")
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
