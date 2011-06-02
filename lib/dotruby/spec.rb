module DotRuby

  # Specific Specification.
  #
  class Spec

    #
    def initialize(data={})
      @revision = data['revision'] ||
                  data[:revision]  ||
                  CURRENT_REVISION

      extend DotRuby.v(@revision)::Attributes
      extend DotRuby.v(@revision)::Canonical

      initialize_defaults

      merge!(data)
    end

    #
    # Access metadata with hash-like getter method.
    #
    # @param [String, Symbol] key
    #   The name of the metadata field.
    #
    def [](key)
      send(key)
    end

    #
    # Assign metadata with hash-like setter method.
    #
    # @param [String, Symbol] key
    #   The name of the metadata field.
    #
    # @param [Object] value
    #   The value of the metadata field.
    #
    def []=(key, value)
      send("#{key}=", value)      
    end

    #
    # Merge data source into metadata.
    #
    # @param [Hash] data
    #   The data source which responds to #each like a Hash.
    #
    def merge!(data)
      data.each do |key, value|
        self[key] = value
      end
    end

    #
    # Convert metadata to a Hash.
    #
    # @returns [Object]
    #
    def to_h
      data = {}
      instance_variables.each do |iv|
        name = iv.to_s.sub(/^@/,'')
        data[name] = send(name)
      end
      data
    end

    # Save metadata to file.
    #
    # @param [String] file
    #   The file name in which to save the metadata as YAML.
    #
    def save!(file='.ruby')
      File.open(file, 'w') do |f|
        f << to_h.to_yaml
      end
    end

  end

end
