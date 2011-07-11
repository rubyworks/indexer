module DotRuby

  # TODO: Rename to `Specification`? And "alias" as `Spec`? Or is
  # `Metadata` a better name for this? Most users will just use
  # `DotRuby.load()` anyway.
  module Spec

    # Default file name of `.ruby` file. It is obviously `.ruby` ;-)
    FILE_NAME = '.ruby'

    # Revision factory return a versioned instance of Specification.
    #
    # @param [Hash] data
    #   The metadata to populate the instance.
    #
    def self.new(data={})
      revision = data['revision'] || data[:revision]
      unless revision
        revison          = CURRENT_REVISION
        data['revision'] = CURRENT_REVISION
      end
      V[revision]::Specification.new(data)
    end

    # Read `.ruby` from file.
    #
    # @param [String] file
    #   The file name from which to read the YAML metadata.
    #
    def self.read(file)
      data     = YAML.load_file(file)
      revision = data['revision'] || data[:revision]
      unless revision
        # TODO: raise error instead ?
        revison          = CURRENT_REVISION
        data['revision'] = CURRENT_REVISION
      end
      valid_data = V[revision]::Validator.new(data).to_h
      V[revision]::Specification.new(valid_data)
    end

    # Find project root and read `.ruby` file.
    #
    # @param [String] from
    #   The directory from which to start the upward search.
    #
    def self.find(from=Dir.pwd)
      file = File.join(root(from),FILE_NAME)
      read(file)
    end

    # Unlike #read, the #load method does not hold the
    # input data to the strict canonical spec.
    #
    # @param [String] file
    #   The file name from which to read the YAML metadata.
    #
    def self.load(file)
      data     = YAML.load_file(file)
      revision = data['revision'] || data[:revision]
      unless revision
        # TODO: raise error instead ?
        revison          = CURRENT_REVISION
        data['revision'] = CURRENT_REVISION
      end
      V[revision]::Specification.new(data)
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
      path = File.expand_path(from)
      while path != '/'
        if File.file?(File.join(path,FILE_NAME))
          return path
        else
          path = File.dirname(path)
        end
        raise DotRuby::Error, "No .ruby file found."
      end

      raise("could not locate the #{FILE_NAME} file")
    end

  end

end
