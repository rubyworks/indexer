module DotRuby

  module HashLike

    #
    # Access metadata with hash-like getter method.
    #
    # @param [String, Symbol] key
    #   The name of the metadata field.
    #
    # @return [Object]
    #   The value associated with the key.
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
    # @returns [Hash{String => Object}]
    #
    def to_h
      data = {}

      instance_variables.each do |iv|
        name = iv.to_s[1..-1]

        data[name] = send(name)
      end

      data
    end

    #
    # Converts the Hash-like object to YAML.
    #
    # @param [IO] io
    #   The stream to write the YAML to.
    #
    def to_yaml(io)
      to_h.to_yaml(io)
    end

  end

end
