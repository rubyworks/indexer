module Indexer

  # The Engine class models the name and version of a
  # the language necessray to run the software.
  #
  class Engine < Model

    # Parse `data` into a Dependency instance.
    #
    # TODO: What about respond_to?(:to_str) for String, etc.
    def self.parse(data)
      case data
      when Engine
        data
      when String
        parse_string(data)
      when Array
        parse_array(data)
      when Hash
        parse_hash(data)
      else
        raise(ValidationError, "Engine")
      end
    end

  private

    #
    #
    def self.parse_string(data)
      name, version = data.split(/\s+/)
      new(:name=>name, :version=>version)
    end

    #
    #
    def self.parse_array(data)
      name, version = *data
      new(:name=>name, :version=>version)
    end

    #
    #
    def self.parse_hash(data)
      new(data)
    end

  public

    #
    # The name of the package that causes the conflict.
    #
    # Yea it's *ALWAYS* THEIR fault ;-)
    #
    attr :name

    #
    # Set the name of the package.
    #
    def name=(name)
      @data[:name] = name.to_s
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
      @data[:version] = Version::Constraint.parse(version)
    end

    #
    #
    #
    def to_h
      {'name'=>name, 'version'=>version.to_s}
    end

  end

end
