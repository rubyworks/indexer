module DotRuby
  module V0
    # Dependency class is essentially the same as {Requirement}, but
    # a dependecny represents a binary package requirement, that would
    # need to be installed using a operating systems own package management
    # system, or installed manually.
    #--
    # TODO: Dependency can probably be a sublcass of Requirement.
    # It differs only in that Binary Packcages MIGHT require some
    # additional information --but as of yet that's not the case.
    #++
    class Dependency

      # The Dependency class requires Repository.
      if RUBY_VERSION > '1.9'
        require_relative 'repository'
      else
        require 'dotruby/v0/repository'
      end

      # Parse `data` into a Dependency instance.
      #
      # TODO: What about respond_to?(:to_str) for String, etc.
      def self.parse(data)
        case data
        when String
          parse_string(data)
        when Array
          parse_array(data)
        when Hash
          parse_hash(data)
        else
          raise(InvalidMetadata, "dependency")
        end
      end

    private

      #
      #
      def self.parse_hash(data)
        name = data.delete('name') || data.delete(:name)
        new(name, data)
      end

      #
      #
      def self.parse_string(data)
        name, version, *groups = data.split(/\s+/)
        ## remove parenthesis
        groups.first.sub!(/^\(/, '')
        groups.last.chomp!(')')
        ## new instance
        new(name, :version=>version, :groups=>groups)
      end

      #
      #
      #
      def self.parse_array(data)
        name, data = *array
        case data
        when Hash
          new(name, data)
        when String
          parse_string(name + " " + data)
        else
          raise(InvalidMetadata, "dependency")
        end
      end

      # Create new instance of Dependency.
      #
      def initialize(name, specifics={})
        @name = name.to_s

        specifics.each do |key, value|
          send("#{}=", value)
        end
      end

    public

      #
      # Set the dependency's runtime flag.
      #
      # @param [Boolean] true/false development dependency?
      #
      def development=(boolean)
        @development = !!boolean
      end

      #
      # Returns `true` if the dependency is a development dependency.
      #
      # @return [Boolean] development dependency?
      def development?
        @development
      end

      #
      # Returns `true` if the dependency is a runtime dependency.
      #
      # @return [Boolean] runtime dependency?
      def runtime?
        ! @development
      end

      #
      # The dependency's version constraint.
      #
      # @return [Version::Constraint] version constraint
      #
      attr_reader :version

      #
      # Set the version constraint.
      #
      # @param version [String,Array,Version::Constraint]
      #   Version constraint(s)
      #
      def version=(version)
        @version = Version::Constraint.parse(version)
      end

      #
      alias :versions= :version=

      #
      # The groups to which the dependency belongs.
      #
      # @return [Array] list of groups
      #
      attr_reader :groups

      #
      # Set the groups to which the dependency belongs.
      #
      # @return [Array<String>, String] list of groups
      #
      def groups=(groups)
        @groups = [groups].flatten
      end

      #
      alias group= groups=

      #
      # Is the dependency optional? An optional dependency is recommended
      # but not strictly necessary.
      #
      # @return [Boolean] optional dependency?
      def optional?
        @optional
      end

      #
      # Set optional.
      #
      # @param [Boolean] optional dependency?
      #
      def optional=(boolean)
        @optional = !!boolean
      end

      #
      # The public repository resource in which the dependency source code
      # can be found.
      #
      # @return [Repository] repository
      attr_reader :repository

      #
      # Set the public repository resource in which the dependency
      # source code can be found.
      #
      def repository=(repository)
        @repository = Repository.parse(repository)
      end

      alias :repo :repository
      alias :repo= :repository=

    end
  end
end
