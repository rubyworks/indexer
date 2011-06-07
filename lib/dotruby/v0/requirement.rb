module DotRuby

  # Requirement class.
  #
  # QUESTION: Does Requirement really need to handle multiple version constraints?
  # Currently this only supports one version constraint.
  class Requirement

    # The Requirement class requires Repository.
    if RUBY_VERSION > '1.9'
      require_relative 'repository'
    else
      require 'dotruby/v0/repository'
    end

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
        raise(InvalidMetadata, "requirement")
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
        raise(InvalidMetadata, "requirement")
      end
    end

    # Create new instance of Requirement.
    #
    def initialize(name, specifics={})
      @name = name.to_s

      specifics.each do |key, value|
        send("#{}=", value)
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
    def version=(version)
      @version = Version::Constraint.parse(version)
    end

    #
    # Returns true if the requirement is a runtime requirement.
    #
    def development?
      @development
    end

    #
    # Set the requirement's development flag.
    #
    # @param [Boolean] true/false runtime requirement
    #
    def development=(boolean)
      @development = !!boolean
    end

    #
    #
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
    alias group groups
    alias group= groups=

    #
    # Is the requirment optional? An optional requirement is recommended
    # but not strictly necessary.
    #
    def optional?
      @optional
    end

    #
    # Set
    #
    def optional=(boolean)
      @optional = !!boolean
    end

    #
    # The public repository resource in which the requirement source code
    # can be found.
    #
    attr_reader :repo

    #
    # Set the public repository resource in which the requirement
    # source code can be found.
    #
    def repo=(repo)
      @repo = Repository.parse(repo)
    end

  end

end
