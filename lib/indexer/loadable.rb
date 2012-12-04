module Indexer

  module Loadable

    #
    # Open metadata file and ensure strict validation to canonical format.
    #
    # @param [String] file or directory
    #   The file name from which to read the YAML metadata,
    #   or a directory from which to lookup the file.
    #
    def open(file=Dir.pwd)
      file = find(file) if File.directory?(file)
      valid(YAML.load_file(file))
    end

    #
    # Like #open, but do not ensure strict validation to canonical format.
    #
    # @param [String] file or directory
    #   The file name from which to read the YAML metadata,
    #   or a directory from which to lookup the file.
    #
    def read(file=Dir.pwd)
      file = find(file) if File.directory?(file)
      new(YAML.load_file(file))  
    end

    #
    # Create new Metadata instance from atypical sources.
    #
    # TODO: Use Importer to construct Metadata instance.
    #
    def import(*sources)
    end

    #
    # Load from YAML string or IO.
    #
    # @param [String,#read] String or IO object
    #   The file name from which to read the YAML metadata.
    #
    def load(io)
      new(YAML.load(io))
    end

    #
    # Load from YAML file.
    #
    # @param [String] file
    #   The file name from which to read the YAML metadata.
    #
    def load_file(file)
      new(YAML.load_file(file))
    end

    #
    # Find project root and read the index file.
    #
    # @param [String] from
    #   The directory from which to start the upward search.
    #
    def find(from=Dir.pwd)
      File.join(root(from), LOCK_FILE)
    end

    #
    # Find project root by looking upward for a locked metadata file.
    #
    # @param [String] from
    #   The directory from which to start the upward search.
    #
    # @return [String]
    #   The path to the locked metadata file.
    #
    # @raise [Errno::ENOENT]
    #   The locked metadata file could not be located.
    #
    def root(from=Dir.pwd)
      if not path = exists?(from)
        lock_file_missing(from)
      end
      path
    end

    #
    # Does a locked metadata file exist?
    #
    # @return [true,false] Whether locked metadata file exists.
    #
    def exists?(from=Dir.pwd)
      home = File.expand_path('~')
      path = File.expand_path(from)
      while path != '/' and path != home
        if File.file?(File.join(path,LOCK_FILE))
          return path
        else
          path = File.dirname(path)
        end
        false #lock_file_missing(from)
      end
      false #lock_file_missing(from)
    end

    #
    # Raise lock file missing error.
    #
    def lock_file_missing(from=nil)
      raise Error.exception("could not locate locked metadata", Errno::ENOENT)
    end

    #
    # Alias for exists?
    #
    def exist?(from=Dir.pwd)
      exists?(from)
    end

    #
    def ensure_locked
      unless exists?
        files = [USER_FILE]
        Importer.import(*files)
      end
    end

  end

end
