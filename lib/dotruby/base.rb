module DotRuby

  # Base class for Validator and Specification classes.
  class Base
    #include HashLike

    # DotRuby uses a strict revision system.
    attr :revision

    # Set the revision.
    def revision=(value)
      @data['revision'] = value.to_i
    end

    # New instance.
    #
    # @param [Hash] data
    #   The metadata to populate the instance.
    #
    def initialize(data={})
      initialize_attributes

      merge!(data)
    end

    #
    # Access metadata with hash-like getter method.
    #
    # @param [String, Symbol] key
    #   The name of the metadata field.
    #
    # @return [Object]
    #   The value associated with the key.
    #
    # @raise [ArgumentError]
    #   The key is not known.
    #
    #--
    # TODO: If key does exist, should it return nil?
    #++
    def [](key)
      __send__("#{key}")
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
    # @raise [ArgumentError]
    #   The key is not known.
    #
    def []=(key, value)
      #unless self.class.attributes.include?(key)
      #  #error = ArgumentError.new("unknown attribute: #{key.inspect}")
      #  #error.extend Error
      #  #raise(error)
      #end
      __send__("#{key}=", value)
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
    #
    def key?(name)
      @data.key?(name.to_s)
    end

    #
    # Convert metadata to a Hash.
    #
    # @return [Hash{String => Object}]
    #
    def to_h
      #data = {}
      #@@attributes.each do |key|
      #  data[key.to_s] = __send__(name)
      #end
      #data
      @data.dup
    end

    #
    # Converts the Hash-like object to YAML.
    #
    # @param [Hash] opts
    #   Options used by YAML.
    #
    # TODO: Should we have #to_yaml in here?
    def to_yaml(io={})
      to_h.to_yaml(io)
    end

  private

    #
    def validate(value, field, *types)
      types.each do |type|
        Valid.send(type, value, field)
      end
      return value
    end

  end

end

class Hash
  def to_h; self; end unless method_defined?(:to_h)
end
