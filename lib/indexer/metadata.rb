require_relative 'loadable'
require_relative 'attributes'
require_relative 'conversion'
require_relative 'validator'

module Indexer

  # Conventional interface for specification provides convenience 
  # for developers. It offers method aliases and models various parts
  # of the specification with useful classes.
  #
  class Metadata < Model
    extend Loadable

    include Attributes
    include Conversion

    class << self
      private
      alias :create :new
    end

    #
    # Revision factory returns a versioned instance of the model class.
    #
    # @param [Hash] data
    #   The data to populate the instance.
    #
    def self.new(data={})
      data = revise(data)
      super(data)
    end

    #
    # Load metadata, ensuring canoncial validity.
    #
    # @param [String] data
    #   The data to be validate and then to populate the instance.
    #
    def self.valid(data)
      data = revise(data)
      data = Validator.new(data).to_h
      create(data)
    end

    #
    # Update metadata to current revision if using old revision.
    #
    def self.revise(data)
      Revision.upconvert(data)
    end

    #
    # Create a new Meta::Spec given a Gem::Specification or .gemspec file.
    #
    # @param [Gem::Specification,String] gemspec
    #   RubyGems Gem::Specification object or path to .gemspec file.
    #
    def self.from_gemspec(gemspec)
      new.import_gemspec(gemspec)
    end


    # -- Writers ------------------------------------------------------------

    #
    # Set the revision. This is in a sense a dummy setting, since the actual
    # revision is alwasy the latest.
    #
    def revision=(value)
      @data['revision'] = value.to_i
    end

    #
    # Set the revision. This is in a sense a dummy setting, since the actual
    # revision is alwasy the latest.
    #
    def type=(value)
      Valid.type!(value, :type)
      @data['type'] = type.to_str
    end

    #
    # Sources for building index file.
    #
    # @param [String, Array] path(s)
    #   Paths from which metadata can be extracted.
    #
    def sources=(list)
      @data[:sources] = [list].flatten
    end

    #
    alias :source  :sources
    alias :source= :sources=

    #
    # Sets the name of the project.
    #
    # @param [String] name
    #   The new name of the project.
    #
    def name=(name)
      name = name.to_s if Symbol === name
      Valid.name!(name, :name)
      @data[:name]  = name.to_str.downcase
      @data[:title] = @data[:name].capitalize unless @data[:title]  # TODO: use #titlecase
      @data[:name]
    end

    #
    # Title is sanitized so that all white space is reduced to a
    # single space character.
    #
    def title=(title)
      Valid.oneline!(title, :title)
      @data[:title] = title.to_str.gsub(/\s+/, ' ')
    end

    #
    # The toplevel namespace of API, e.g. `module Foo` or `class Bar`,
    # would be `"Foo"` or `"Bar"`, repectively.
    #
    # @param [String] namespace
    #   The new toplevel namespace of the project's API.
    #
    def namespace=(namespace)
      Valid.constant!(namespace)
      @data[:namespace] = namespace
    end

    #
    # Summary is sanitized to only have one line of text.
    #
    def summary=(summary)
      Valid.string!(summary, :summary)
      @data[:summary] = summary.to_str.gsub(/\s+/, ' ')
    end

    #
    # Sets the version of the project.
    #
    # @param [Hash, String, Array, Version::Number] version
    #   The version from the metadata file.
    #
    # @raise [ValidationError]
    #   The version must either be a `String`, `Hash` or `Array`.
    #
    def version=(version)
      case version
      when Version::Number
        @data[:version] = version
      when Hash
        major = version['major'] || version[:major]
        minor = version['minor'] || version[:minor]
        patch = version['patch'] || version[:patch]
        build = version['build'] || version[:build]
        @data[:version] = Version::Number.new(major,minor,patch,build)
      when String
        @data[:version] = Version::Number.parse(version.to_s)
      when Array
        @data[:version] = Version::Number.new(*version)
      else
        raise(ValidationError,"version must be a Hash or a String")
      end
    end

    #
    # Codename is the name of the particular version.
    #
    def codename=(codename)
      codename = codename.to_s if Symbol === codename
      Valid.oneline!(codename, :codename)
      @data[:codename] = codename.to_str
    end

    #
    # Sets the production date of the project.
    #
    # @param [String,Date,Time,DateTime] date
    #   The production date for this version.
    #
    def date=(date)
      @data[:date] = \
        case date
        when String
          begin
            Date.parse(date)
          rescue ArgumentError
            raise ValidationError, "invalid date for `date' - #{date.inspect}"
          end
        when Date, Time, DateTime
          date
        else
          raise ValidationError, "invalid date for `date' - #{date.inspect}"
        end
    end

    #
    # Sets the creation date of the project.
    #
    # @param [String,Date,Time,DateTime] date
    #   The creation date of this project.
    #
    def created=(date)
      @data[:created] = \
        case date
        when String
         Valid.utc_date!(date)
         Date.parse(date)
        when Date, Time, DateTime
         date
        else
         raise ValidationError, "invalid date for `created' - #{date.inspect}"
        end
    end

    # Set the copyrights and licenses for the project.
    #
    # Copyrights SHOULD be in order of significance. The first license 
    # given is taken to be the project's primary license.
    #
    # License fields SHOULD be offically recognized identifiers such
    # as "GPL-3.0" as defined by SPDX (http://). 
    #
    # @example
    #    spec.copyrights = [ 
    #      {
    #        'year'    => '2010',
    #        'holder'  => 'Thomas T. Thomas',
    #        'license' => "MIT"
    #      }
    #    ]
    #
    # @param [Array<Hash,String,Array>]
    #   The copyrights and licenses of the project.
    #
    def copyrights=(copyrights)
      @data[:copyrights] = \
        case copyrights
        when String
          [Copyright.parse(copyrights, @_license)]
        when Hash
          [Copyright.parse(copyrights, @_license)]
        when Array
          copyrights.map do |copyright|
            Copyright.parse(copyright, @_license)
          end
        else
          raise(ValidationError, "copyright must be a String, Hash or Array")
        end
      @data[:copyrights]
    end

    #
    # Singular form of `#copyrights=`. This is similar to `#copyrights=`
    # but expects the parameter to represent only one copyright.
    #
    def copyright=(copyright)
      @data[:copyrights] = [Copyright.parse(copyright)]
    end

    # TODO: Should their be a "primary" license field ?

    #
    # Set copyright license for all copyright holders.
    #
    def license=(license)
      if copyrights = @data[:copyrights]
        copyrights.each do |c|
          c.license = license  # TODO: unless c.license ?
        end
      end
      @_license = license
    end

    # Set the authors of the project.
    #
    # @param [Array<String>, String] authors
    #   The originating authors of the project.
    #
    def authors=(authors)
      @data[:authors] = (
        list = Array(authors).map do |a|
                 Author.parse(a)
               end
        warn "Duplicate authors listed" if list != list.uniq
        list
      )
    end

    #
    alias author= authors=

    #
    # Set the orgnaization to which the project belongs.
    #
    # @param [String] organization
    #   The name of the organization.
    #
    def organizations=(organizations)
      @data[:organizations] = (
        list = Array(organizations).map do |org|
                 Organization.parse(org)
               end
        warn "Duplicate organizations listed" if list != list.uniq
        list
      )
    end

    #
    alias :organization= :organizations=

    # Company is a typical synonym for organization.
    alias :company :organizations
    alias :company= :organizations=
    alias :companies :organizations=
    alias :companies= :organizations=

    # TODO: should we warn if directory does not exist?

    # Sets the require paths of the project.
    #
    # @param [Array<String>, String] paths
    #   The require-paths or a glob-pattern.
    #
    def load_path=(paths)
      @data[:load_path] = \
        Array(paths).map do |path|
          Valid.path!(path)
          path
        end
    end

    # List of language engine/version family supported.
    def engines=(value)
      @data[:engines] = (
        a = [value].flatten
        a.each{ |x| Valid.oneline!(x) }
        a
      )
    end

    #
    # List of platforms supported.
    #
    # @deprecated
    #
    def platforms=(value)
      @data[:platforms] = (
        a = [value].flatten
        a.each{ |x| Valid.oneline!(x) }
        a
      )
    end

    #
    # Sets the requirements of the project. Also commonly called dependencies.
    #
    # @param [Array<Hash>, Hash{String=>Hash}, Hash{String=>String}] requirements
    #   The requirement details.
    #
    # @raise [ValidationError]
    #   The requirements must be an `Array` or `Hash`.
    #
    def requirements=(requirements)
      requirements = [requirements] if String === requirements
      case requirements
      when Array, Hash
        @data[:requirements].clear
        requirements.each do |specifics|
          @data[:requirements] << Requirement.parse(specifics)
        end
      else
        raise(ValidationError,"requirements must be an Array or Hash")
      end
    end

    #
    # Dependencies is an alias for requirements.
    #
    alias :dependencies  :requirements
    alias :dependencies= :requirements=

    #
    # Sets the packages with which this package is known to have
    # incompatibilites.
    #
    # @param [Array<Hash>, Hash{String=>String}] conflicts
    #   The conflicts for the project.
    #
    # @raise [ValidationError]
    #   The conflicts list must be an `Array` or `Hash`.
    #
    # @todo lets get rid of the type check here and let the #parse method do it.
    #
    def conflicts=(conflicts)
      case conflicts
      when Array, Hash
        @data[:conflicts].clear
        conflicts.each do |specifics|
          @data[:conflicts] << Conflict.parse(specifics)
        end
      else
        raise(ValidationError, "conflicts must be an Array or Hash")
      end
    end

    #
    # Sets the packages this package could (more or less) replace.
    # 
    # @param [Array<String>] alternatives
    #   The alternatives for the project.
    #
    def alternatives=(alternatives)
      Valid.array!(alternatives, :alternatives)

      @data[:alternatives].clear

      alternatives.to_ary.each do |name|
        @data[:alternatives] << name.to_s
      end
    end

    #
    # Sets the categories for this project.
    # 
    # @param [Array<String>] categories
    #   List of purpose categories for the project.
    #
    def categories=(categories)
      categories = Array(categories)

      @data[:categories].clear

      categories.to_ary.each do |name|
        Valid.oneline!(name.to_s)
        @data[:categories] << name.to_s
      end
    end

    #
    # Suite must be a single line string.
    #
    # @param [String] suite
    #   The suite to which the project belongs.
    #
    def suite=(value)
      Valid.oneline!(value, :suite)
      @data[:suite] = value
    end

    #
    # Sets the repostiories this project has.
    # 
    # @param [Array<String>, Hash] repositories
    #   The repositories for the project.
    #
    def repositories=(repositories)
      case repositories
      when Hash, Array
        @data[:repositories].clear
        repositories.each do |specifics|
          @data[:repositories] << Repository.parse(specifics)
        end
      else
        raise(ValidationError, "repositories must be an Array or Hash")
      end
    end

    #
    # Set the resources for the project.
    #
    # @param [Array,Hash] resources
    #   A list or map of resources.
    #
    def resources=(resources)
      case resources
      when Array
        @data[:resources].clear
        resources.each do |data|
          @data[:resources] << Resource.parse(data)
        end
      when Hash
        @data[:resources].clear
        resources.each do |type, uri|
          @data[:resources] << Resource.new(:uri=>uri, :type=>type.to_s)
        end
      else
        raise(ValidationError, "repositories must be an Array or Hash")
      end
    end

    #
    # The webcvs prefix must be a valid URI.
    #
    # @param [String] uri
    #   The webcvs prefix, which must be a valid URI.
    #
    def webcvs=(uri)
      Valid.uri!(uri, :webcvs)
      @data[:webcvs] = uri
    end

    #
    # Sets the post-install message of the project.
    #
    # @param [Array, String] message
    #   The post-installation message.
    #
    # @return [String]
    #   The new post-installation message.
    #
    def install_message=(message)
      @data[:install_message] = \
        case message
        when Array
          message.join($/)
        else
          Valid.string!(message)
          message.to_str
        end
    end

    ##
    ## Set extraneous developer-defined metdata.
    ##
    #def extra=(extra)
    #  unless extra.kind_of?(Hash)
    #    raise(ValidationError, "extra must be a Hash")
    #  end
    #  @data[:extra] = extra
    #end

    # -- Utility Methods ----------------------------------------------------

    #
    # Adds a new requirement.
    #
    # @param [String] name
    #   The name of the requirement.
    #
    # @param [Hash] specifics
    #   The specifics of the requirement.
    #
    def add_requirement(name, specifics)
      requirements << Requirement.parse([name, specifics])
    end

    #
    # Same as #add_requirement.
    #
    # @param [String] name
    #   The name of the dependency.
    #
    # @param [Hash] specifics
    #   The specifics of the dependency.
    #
    alias add_dependency add_requirement

    #
    # Adds a new conflict.
    #
    # @param [String] name
    #   The name of the conflict package.
    #
    # @param [Hash] specifics
    #   The specifics of the conflict package.
    #
    def add_conflict(name, specifics)
      conflicts << Requirement.parse([name, specifics])
    end

    #
    # Adds a new alternative.
    #
    # @param [String] name
    #   The name of the alternative.
    #
    def add_alternative(name)
      alternatives << name.to_s
    end

    #
    #
    #
    def add_repository(id, url, scm=nil)
      repositories << Repository.parse(:id=>id, :url=>url, :scm=>scm)
    end

    #
    # A specification is not valid without a name and version.
    #
    # @return [Boolean] valid specification?
    #
    def valid?
      return false unless name
      return false unless version
      true
    end

# TODO: What was used for again, load_path ?
=begin
  #
  # Iterates over the paths.
  #
  # @param [Array<String>, String] paths
  #   The paths or path glob pattern to iterate over.
  #
  # @yield [path]
  #   The given block will be passed each individual path.
  #
  # @yieldparam [String] path
  #   An individual path.
  #
  def each_path(paths,&block)
    case paths
    when Array
      paths.each(&block)
    when String
      Dir.glob(paths,&block)  # TODO: should we be going this?
    else
      raise(ValidationError, "invalid path")
    end
  end

  private :each_path
=end

    # -- Calculations -------------------------------------------------------

    #
    # The primary copyright of the project.
    #
    # @return [String]
    #   The primary copyright for the project.
    #
    def copyright
      copyrights.join("\n")
    end

    #
    # The primary email address of the project. The email address
    # is taken from the first listed author.
    #
    # @return [String, nil]
    #   The primary email address for the project.
    #
    def email
      authors.find{ |a| a.email }
    end

    #
    # Get homepage URI.
    #
    def homepage #(uri=nil)
      #uri ? self.homepage = url
      resources.each do |r|
        if r.type == 'home'
          return r.uri
        end
      end
    end
    alias_method :website, :homepage

    #
    # Convenience method for setting a `hompage` resource.
    #
    # @todo Rename to website?
    #
    def homepage=(uri)
      resource = Resource.new(:name=>'homepage', :type=>'home', :uri=>uri)
      resources.unshift(resource)
      uri
    end
    alias_method :website=, :homepage=

    #
    # Returns the runtime requirements of the project.
    #
    # @return [Array<Requirement>] runtime requirements.
    def runtime_requirements
      requirements.select do |requirement|
        requirement.runtime?
      end
    end

    #
    # Returns the development requirements of the project.
    #
    # @return [Array<Requirement>] development requirements.
    #
    def development_requirements
      requirements.select do |requirement|
        requirement.development?
      end
    end

    #
    # Returns the runtime requirements of the project.
    #
    # @return [Array<Requirement>] runtime requirements.
    def external_requirements
      requirements.select do |requirement|
        requirement.external?
      end
    end

    #
    # Returns the external runtime requirements of the project.
    #
    # @return [Array<Requirement>] external runtime requirements.
    def external_runtime_requirements
      requirements.select do |requirement|
        requirement.external? && requirement.runtime?
      end
    end

    #
    # Returns the external development requirements of the project.
    #
    # @return [Array<Requirement>] external development requirements.
    def external_development_requirements
      requirements.select do |requirement|
        requirement.external? && requirement.development?
      end
    end

    # -- Aliases ------------------------------------------------------------

    #
    #
    # @return [Array] load paths
    def loadpath
      load_path
    end

    #
    # RubyGems term for #load_path.
    #
    def loadpath=(value)
      self.load_path = value
    end

    #
    #
    # @return [Array] load paths
    def require_paths
      load_path
    end

    #
    # RubyGems term for #load_path.
    #
    def require_paths=(value)
      self.load_path = value
    end

    #
    # Alternate short name for #requirements.
    #
    def requires
      requirements
    end

    #
    # Alternate short name for #requirements.
    #
    def requires=(value)
      self.requirements = value
    end

    #
    # Alternate singular form of #engines.
    #
    def engine=(value)
      self.engines = value
    end

    #
    # Alternate singular form of #platforms.
    #
    def platform=(value)
      self.platforms = value
    end

    # -- Conversion ---------------------------------------------------------

    #
    # Convert convenience form of metadata to canonical form.
    #
    # @todo: Make sure this generates the canonical form.
    #
    def to_h
      date = self.date || Time.now

      h = super

      h['revision']      = REVISION
      h['version']       = version.to_s

      h['date']          = date.strftime('%Y-%m-%d')
      h['created']       = created.strftime('%Y-%m-%d') if created

      h['authors']       = authors.map       { |x| x.to_h }
      h['organizations'] = organizations.map { |x| x.to_h }
      h['copyrights']    = copyrights.map    { |x| x.to_h }
      h['requirements']  = requirements.map  { |x| x.to_h }
      h['conflicts']     = conflicts.map     { |x| x.to_h }
      h['repositories']  = repositories.map  { |x| x.to_h }
      h['resources']     = resources.map     { |x| x.to_h }

      h
    end

    # Create nicely formated project "about" text.
    #
    # @return [String] Formatted about text.
    #
    def about(*parts)
      s = []
      parts = [:header, :description, :resources, :copyright] if parts.empty?
      parts.each do |part|
        case part.to_sym
        when :header
          s << "%s %s (%s-%s)" % [title, version, name, version]
        when :title
          s << title
        when :package
          s << "%s-%s" % [name, version]
        when :description
          s << description || summary
        when :summary
          s << summary
        when :resources
          s << resources.map{ |resource|
            "%s: %s" % [resource.label || resource.type, resource.uri]
          }.join("\n")
        when :repositories
          s << repositories.map{ |repo|
            "%s" % [repo.uri]
          }.join("\n")
        when :copyright, :copyrights
          s << copyrights.map{ |c|
            "Copyright (c) %s %s (%s)" % [c.year, c.holder, c.license]
          }.join("\n")
        else
          s << __send__(part)
        end
      end
      s.join("\n\n")
    end

    # Save metadata lock file.
    #
    # @param [String] file
    #   The file name in which to save the metadata as YAML.
    #
    def save!(file=LOCK_FILE)
      v = Validator.new(to_h)
      v.save!(file)
    end

  protected

    #
    # Initializes the {Metadata} attributes.
    #
    def initialize_attributes
      super
    end

  end

end
