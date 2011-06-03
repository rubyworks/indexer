module DotRuby

  # Specific Specification.
  #
  class Spec
    include HashLike

    #
    def initialize(data={})
      @revision = data['revision'] ||
                  data[:revision]  ||
                  CURRENT_REVISION

      extend DotRuby.v(@revision)::Attributes
      extend DotRuby.v(@revision)::Canonical

      initialize_attributes

      merge!(data)
    end

    # Save .ruby file.
    #
    # @param [String] file
    #   The file name in which to save the metadata as YAML.
    #
    def save!(file='.ruby')
      File.open(file, 'w') do |f|
        f << to_h.to_yaml
      end
    end

    # Read .ruby from file.
    #
    # @param [String] file
    #   The file name in which to read the YAML metadata.
    #
    def self.read(file)
      new(YAML.load(File.new(file)))
    end

    # Find project root and read .ruby file.
    #
    # @param [String] from
    #   The directory from which to start the upward search.
    #
    def self.find(from=Dir.pwd)
      read(File.join(root(from),'.ruby'))
    end

    # Find project root by looking upward for a .ruby file.
    #
    # @param [String] from
    #   The directory from which to start the upward search.
    #
    def self.root(from=Dir.pwd)
      Dir.ascend(from) do |path|
        if File.file?(File.join(path, '.ruby'))
          break path
        end
      end
    end

  end

end
