module DotRuby
  module V0
    # The Conflict class models the name and versions of
    # packages that have know incompatibilities.
    #
    class Conflict < Model

      # Parse `data` into a Dependency instance.
      #
      # TODO: What about respond_to?(:to_str) for String, etc.
      def self.parse(data)
        case data
        when String
          parse_string(data)
        when Array
          new(*data)
        when Hash
          parse_hash(data)
        else
          raise(ValidationError, "Conflict")
        end
      end

    private

      #
      #
      def self.parse_string(data)
        name, version = data.split(/\s+/)
        new(name, version)
      end

      #
      #
      def self.parse_hash(data)
        name    = data.delete('name')    || data.delete(:name)
        version = data.delete('version') || data.delete(:version)
        new(name, version)
      end

      # Initialize new instance of Conflict.
      #
      def initialize(name, version=nil)
        self.name    = name
        self.version = version
      end

    public

      #
      # The name of the package that causes the conflict.
      #
      # Yea it's *ALWAYS* THEIR fault ;-)
      #
      attr_reader :name

      #
      # Set the name of the package.
      #
      def name=(name)
        @name = name.to_s
      end

      #
      # The versions constraint of the conflicting package.
      # This is used when only certain versions of the package
      # are the problem.
      #
      attr_reader :version

      #
      # Set the version constraint.
      #
      def version=(version)
        @version = Version::Constraint.parse(version)
      end

    end
  end
end
