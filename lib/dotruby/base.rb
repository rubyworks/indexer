module DotRuby

  # Base class for Data and Spec classes.
  class Base
    include HashLike

    # Default file name of `.ruby` file. It is obviously `.ruby` ;-)
    FILE_NAME = '.ruby'

    # New instance.
    def initialize(data={})
      @revision = data.delete('revision') || CURRENT_REVISION

      extend DotRuby.v(@revision)::Attributes

      ## @todo how best to handle this?
      if Spec === self
        extend DotRuby.v(@revision)::Conventional
      else
        extend DotRuby.v(@revision)::Canonical
      end

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

  end

end
