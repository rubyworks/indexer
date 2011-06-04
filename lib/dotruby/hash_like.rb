require 'dotruby/exceptions/metadata'

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
    # @raise [InvalidMetadata]
    #   The key is not known.
    #
    def [](key)
      unless respond_to?(key)
        raise(InvalidMetadata,"unknown attribute: #{key.inspect}")
      end

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
    # @return [Object]
    #   The newly set value.
    #
    # @raise [InvalidMetadata]
    #   The key is not known.
    #
    def []=(key, value)
      setter = "#{key}="

      unless respond_to?(setter)
        raise(InvalidMetadata,"unknown attribute: #{key.inspect}")
      end

      send(setter, value)      
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
    # @return [Hash{String => Object}]
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
