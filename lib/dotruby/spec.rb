require 'dotruby/metadata'

module DotRuby

  # Specific Specification.
  #
  class Spec < Metadata
    FILE_NAME = '.rbuy'

    include HashLike

    # Save `.ruby` file.
    #
    # @param [String] file
    #   The file name in which to save the metadata as YAML.
    #
    def save!(file=FILE_NAME)
      File.open(file, 'w') do |f|
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
