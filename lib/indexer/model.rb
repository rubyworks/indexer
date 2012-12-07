module Indexer

  class Model

    class << self

=begin
      #
      # Revision factory returns a versioned instance of the model class.
      #
      # @param [Hash] data
      #   The data to populate the instance.
      #
      def new(data={})
        revision, data = revised(data)
        basename = name.split('::').last
        V[revision].const_get(basename).new(data)
      end

      #
      # Revision factory returns a validated versioned instance of the model class.
      #
      # @param [Hash] data
      #   The data to populate the instance.
      #
      def valid(data)
        revision, data = revised(data)
        basename = name.split('::').last
        V[revision].const_get(basename).valid(data)
      end

      #
      # When Model is inherited alias `#valid` to `#new` and setup an inherited
      # callback for subclass which will do the same for `#new`.
      #
      # @param [Class] child
      #   The subclass inheriting Model.
      #
      def inherited(child)
        def child.inherited(child)
          class << child
            alias :new :_new
            alias :valid :_new
          end
        end
      end
=end

      #
      #
      #
      def attr_reader(name)
        module_eval %{
          def #{name}
            @data[:#{name}]
          end
        }
      end

      #
      #
      #
      alias :attr :attr_reader

      #
      #
      #
      def attr_writer(name)
        module_eval %{
          def #{name}=(value)
            @data[:#{name}] = value
          end
        }
      end

    end

    #
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
    # Set default attributes.
    #
    def initialize_attributes
      @data = {}
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
    def [](key)
      if respond_to?(key)
        __send__("#{key}")
      else
        @data[key.to_sym]
      end
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
      if respond_to?("#{key}=")
        __send__("#{key}=", value)
      else
        @data[key.to_sym] = value
      end
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
    #
    def key?(name)
      @data.key?(name.to_sym)
    end

    #
    # Convert metadata to a Hash.
    #
    # @return [Hash{String => Object}]
    #
    def to_h
      h = {}
      #self.class.attributes.each do |key|
      #  h[key.to_s] = __send__(name)
      #end
      @data.each do |k, v|
        h[k.to_s] = v if v
      end
      h
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

    #
    # Models are open collections. Any arbitrary settings can be made
    # in order to support non-specification indexing.
    #
    def method_missing(sym, *args, &blk)
      super(sym, *args, &blk) if blk
      name = sym.to_s
      type = name[-1,1]

      case type
      when '='
        value = (
          case v = args.first
          when String  then String(v)
          when Integer then Integer(v)
          when Float   then Float(v)
          when Array   then Array(v)
          when Hash    then Hash(v)
          else
            raise ValidationError, "custom metadata for `#{sym}' not simple type -- `#{value.class}'"
          end
        )
        @data[name.chomp('=').to_sym] = value
      when '!'
        super(sym, *args, &blk)
      when '?'
        super(sym, *args, &blk)
      else
        key?(name) ? @data[name.to_sym] : nil #super(sym, *args, &blk)
      end
    end

  private

    #
    def store(key, value)
      @data[key.to_sym] = value
    end

    #
    def validate(value, field, *types)
      types.each do |type|
        Valid.send(type, value, field)
      end
      return value
    end

  end

end
