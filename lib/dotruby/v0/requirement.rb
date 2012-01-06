# The Requirement class requires Repository.
if RUBY_VERSION > '1.9'
  require_relative 'repository'
else
  require 'dotruby/v0/repository'
end

module DotRuby
  module V0
    # Requirement class.
    #
    # QUESTION: Does Requirement really need to handle multiple version constraints?
    # Currently this only supports one version constraint.
    class Requirement < Model

      # Parse `data` into a Requirement instance.
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
          raise(ValidationError, "requirement")
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
      def self.parse_string(string)
        case string.strip
        when /^(\w.*?)\s+(.*?)\s*\((.*?)\)$/
          name    = $1
          version = $2
          groups  = $3
        when /^(\w.*?)\s+(.*?)$/
          name    = $1
          version = $2
          groups  = nil
        when /^(\w.*?)$/
          name    = $1
          version = nil
          groups  = nil
        else
          raise(ValidationError, "requirement")
        end

        version = nil                          if version.to_s.strip.empty?
        groups = groups.split(/\s*[,;]?\s+/) if groups

        specifics = {}
        specifics['version']     = version  if version
        specifics['groups']      = groups   if groups

        if groups && !groups.empty? && !groups.include?('runtime')
          specifics['development'] = true     
        end

        new(name, specifics)
      end

      #
      #
      #
      def self.parse_array(array)
        name, data = *array
        case data
        when Hash
          new(name, data)
        when String
          parse_string(name + " " + data)
        else
          raise(ValidationError, "requirement")
        end
      end

      # Create new instance of Requirement.
      #
      def initialize(name, specifics={})
        @name   = name.to_s
        @groups = []

        specifics.each do |key, value|
          send("#{key}=", value)
        end
      end

    public

      #
      #
      attr_reader :name

      #
      #
      def name=(name)
        @name = name.to_s
      end

      #
      # The requirement's version constraint.
      #
      # @return [Version::Constraint] version constraint.
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
      # Returns true if the requirement is a development requirement.
      #
      # @return [Boolean] development requirement?
      def development?
        @development
      end

      #
      # Set the requirement's development flag.
      #
      # @param [Boolean] true/false development requirement
      #
      def development=(boolean)
        @development = !!boolean
      end

      #
      # Return `true` if requirement is a runtime requirement.
      #
      # @return [Boolean] runtime requirement?
      def runtime?
       ! @development
      end

      #
      # The groups to which the requirement belongs.
      #
      # @return [Array] list of groups
      #
      attr_reader :groups

      #
      # Set the groups to which the requirement belongs.
      #
      # @return [Array, String] list of groups
      #
      def groups=(groups)
        @groups = [groups].flatten
      end

      #
      alias :group :groups
      alias :group= :groups=

      #
      # Is the requirment optional? An optional requirement is recommended
      # but not strictly necessary.
      #
      # @return [Boolean] optional requirement?
      def optional?
        @optional
      end

      #
      # Set optional.
      #
      # @param [Boolean] optional requirement?
      #
      def optional=(boolean)
        @optional = !!boolean
      end

      #
      # The public repository resource in which the requirement source code
      # can be found.
      #
      attr_reader :repository

      #
      # Set the public repository resource in which the requirement
      # source code can be found.
      #
      def repository=(repository)
        @repository = Repository.parse(repository)
      end

      alias :repo :repository
      alias :repo= :repository=

      # Convert to canonical hash.
      def to_h
        h = {}
        h['name']        = name
        h['version']     = version.to_s    if version
        h['groups']      = groups          if not groups.empty?
        h['development'] = development?    if development?
        h['repository']  = repository.to_h if repository
        h
      end

    end
  end
end
