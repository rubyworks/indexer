module DotRuby

  # The Specification class models the strict *canonical* specification of
  # the `.ruby` file format. It is a one-to-one mapping with no method aliases
  # or other conveniences. The class is primarily intended for internal use.
  # Developers will typically use the Spec class, which is designed for
  # convenience.
  #
  class Specification
    include HashLike

    #
    FILE_NAME = '.ruby'

    #
    def initialize(data={})
      @revision = data.delete('revision') || CURRENT_REVISION

      extend DotRuby.v(@revision)::Attributes
      extend DotRuby.v(@revision)::Canonical  # not Conventional

      initialize_attributes
      merge!(data)
    end

    # Save `.ruby` file.
    #
    # @param [String] file
    #   The file name in which to save the metadata as YAML.
    #
    def save!(file=FILE_NAME)
      File.open(file, 'w') do |f|
        #f << to_h.to_yaml
        to_yaml(f)
      end
    end

    # Read `.ruby` from file.
    #
    # @param [String] file
    #   The file name in which to read the YAML metadata.
    #
    def self.read(file)
      new(YAML.load_file(file))
    end

    # Find project root and read `.ruby` file.
    #
    # @param [String] from
    #   The directory from which to start the upward search.
    #
    def self.find(from=Dir.pwd)
      read(File.join(root(from),FILE_NAME))
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
