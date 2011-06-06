module DotRuby

  # Spec the specification generalized for the convenience of developers.
  # It offers method aliases and models various parts of the specification 
  # with useful classes.
  #
  class Spec #< Metadata
    include HashLike

    #
    FILE_NAME = '.ruby'

    #
    def initialize(data={})
      @revision = data.delete('revision') || CURRENT_REVISION

      extend DotRuby.v(@revision)::Attributes
      extend DotRuby.v(@revision)::Conventional  # not Canonical

      initialize_attributes
      merge!(data)
    end

    # Save `.ruby` file.
    #
    # @param [String] file
    #   The file name in which to save the metadata as YAML.
    #
    def save!(file='.ruby')
      to_metadata.save!(file)
    end

    # Read `.ruby` from file.
    #
    # @param [String] file
    #   The file name from which to read the YAML metadata.
    #
    def self.read(file)
      Metadata.read(file).to_spec
    end

    # Find project root and read `.ruby` file.
    #
    # @param [String] from
    #   The directory from which to start the upward search.
    #
    def self.find(dir=Dir.pwd)
      Metadata.find(dir).to_spec
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
      Metadata.root(dir)
    end

  end

end
