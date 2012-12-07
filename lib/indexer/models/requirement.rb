module Indexer

  # Requirement class.
  #
  # QUESTION: Does Requirement really need to handle multiple version constraints?
  # Currently this only supports one version constraint.
  #
  class Requirement < Model

    #
    # Parse `data` into a Requirement instance.
    #
    # TODO: What about respond_to?(:to_str) for String, etc.
    #
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
      name = (data.delete('name') || data.delete(:name)).to_s
      # make sure groups are strings
      groups = []
      groups << (data.delete('groups') || data.delete(:groups))
      groups << (data.delete('group')  || data.delete(:group))
      groups = groups.flatten.compact.map{ |g| g.to_s }
      data[:groups] = groups
      #
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
        groups = []
        groups << (data.delete('groups') || data.delete(:groups))
        groups << (data.delete('group')  || data.delete(:group))
        groups = groups.flatten.compact.map{ |g| g.to_s }
        data[:groups] = groups

        new(name.to_s, data)
      when String
        parse_string(name + " " + data)
      else
        raise(ValidationError, "requirement")
      end
    end

    #
    # Create new instance of Requirement.
    #
    def initialize(name, specifics={})
      specifics[:name] = name
      super(specifics)
    end

    #
    def initialize_attributes
      @data = {
        :groups    => [],
        :engines   => [],
        :platforms => [],
        :sources   => []
      }
    end

  public

    #
    #
    attr_reader :name

    #
    #
    def name=(name)
      @data[:name] = name.to_s
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
      @data[:version] = Version::Constraint.parse(version)
    end

    #
    alias :versions= :version=

    #
    # Returns true if the requirement is a development requirement.
    #
    # @return [Boolean] development requirement?
    def development?
      @data[:development]
    end

    #
    # Set the requirement's development flag.
    #
    # @param [Boolean] true/false development requirement
    #
    def development=(boolean)
      @data[:development] = !!boolean
    end

    #
    # Return `true` if requirement is a runtime requirement.
    #
    # @return [Boolean] runtime requirement?
    def runtime?
     ! @data[:development]
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
      @data[:groups] = [groups].flatten
    end

    # Singular alias for #groups.
    alias :group :groups
    alias :group= :groups=

    #
    # Is the requirment optional? An optional requirement is recommended
    # but not strictly necessary.
    #
    # @return [Boolean] optional requirement?
    #
    def optional?
      @data[:optional]
    end

    #
    # Set optional.
    #
    # @param [Boolean] optional requirement?
    #
    def optional=(boolean)
      @data[:optional] = !!boolean
    end

    #
    # Is the requirment external? An external requirement is one that is only
    # available outside the expected packaging system. For a Ruby application, for example,
    # this would be library not available via rubygems.org, such as a C library that is only
    # avaialble via an operating system's package manager or via a direct download using the
    # "make; make install" compile and installation procedure.
    #
    # @return [Boolean] external requirement?
    #
    def external?
      @data[:external]
    end

    #
    # Set external.
    #
    # @param [Boolean] external requirement?
    #
    def external=(boolean)
      @data[:external] = !!boolean
    end

    #
    # Applies only for specified Ruby engines. Each entry can be
    # the `RUBY_ENGINE` value and optionally a version constraint
    # on `RUBY_VERSION`.
    #
    # @return [Array] name and version constraint
    #
    attr :engines

    #
    # Applies only for specified Ruby engines. Each entry can be
    # the `RUBY_ENGINE` value and optionally a version constraint
    # on `RUBY_VERSION`.
    #
    # @example
    #
    #   requirement.engines = [
    #     'ruby 1.8~'
    #   ]
    #
    def engines=(engines)
      @data['engines'] = Array(engines).map do |engine|
        case engine
        when String
          name, vers = engine.strip.split(/\s+/)
          vers = nil if vers.empty?
        when Array
          name, vers = *engine
        when Hash
          name = engine['name']
          vers = engine['version']
        end
        e = {}
        e['name']    = name
        e['version'] = Version::Constraint.parse(vers) if vers
        e
      end
    end

    alias_method :engine,  :engines
    alias_method :engine=, :engines=

    attr :platforms

    #
    # Applies only for specified platforms. The platform must be verbatim
    # `RUBY_PLATFORM` value.
    #
    # @example
    #   requirement.platforms = ['x86_64-linux']
    #
    def platforms=(platforms)
      @data[:platforms] = Array(platforms)
    end

    alias_method :platform,  :platforms
    alias_method :platform=, :platforms=

    #
    # The public repository resource in which the requirement source code
    # can be found.
    #
    attr :repository

    #
    # Set the public repository resource in which the requirement
    # source code can be found.
    #
    def repository=(repository)
      @data[:repository] = Repository.parse(repository)
    end

    alias :repo :repository
    alias :repo= :repository=

    #
    # Places from which the requirement can be obtained. Generally a source
    # should be a URI, but there is no strict requirement. It can be as 
    # simple as a name, e.g. `rubygems` or as specific as a URL to a downloadable
    # `.zip` package.
    #
    # @example
    #   requirement.sources = ['http://rubygems.org']
    #
    attr :sources

    #
    # Set sources.
    #
    def sources=(sources)
      @data[:sources] = Array(sources)
    end

    #
    # Convert to canonical hash.
    #
    def to_h
      h = super

      h['version']     = version.to_s
      h['repository']  = repository.to_h if repository

      h.delete('groups')    if h['groups']    && h['groups'].empty?
      h.delete('engines')   if h['engines']   && h['engines'].empty?
      h.delete('platforms') if h['platforms'] && h['platforms'].empty?
      h.delete('sources')   if h['sources']   && h['sources'].empty?

      h
    end

  private

    # ensure engine entries are strings
    #def engines_to_h
    #  engines.map do |engine|
    #    hash = {}
    #    hash['name'] = engine['name']
    #    hash['version'] = engine['version'].to_s
    #    hash
    #  end
    #end

  end

end
