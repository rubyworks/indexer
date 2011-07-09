# Conventional module requires Attributes module and 
# all the modeling classes.
if RUBY_VERSION > '1.9'
  require_relative 'attributes'
  require_relative 'requirement'
  require_relative 'dependency'
  require_relative 'conflict'
  require_relative 'author'
  require_relative 'copyright'
else
  require 'dotruby/v0/attributes'
  require 'dotruby/v0/requirement'
  require 'dotruby/v0/dependency'
  require 'dotruby/v0/conflict'
  require 'dotruby/v0/author'
  require 'dotruby/v0/copyright'
end

module DotRuby

  # First revision of dotruby specification.
  module V0

    # Conventional mixin is equvialent to the Canonical 
    # mixin but provides a versu liberal interface
    # and additional convenience methods.
    module Conventional

      include Attributes
   
      # -- Writers ------------------------------------------------------------

      # Sets the name of the project.
      #
      # @param [String] name
      #   The new name of the project.
      #
      def name=(name)
        name = name.to_s if Symbol === name
        Valid.name!(name, :name)
        @name  = name.to_str.downcase
        @title = @name.capitalize unless @title  # TODO: use #titlecase
        @name
      end

      # Title is sanitized so that all white space is reduced to a
      # single space character.
      #
      def title=(title)
        Valid.oneline!(title, :title)
        @title = title.to_str.gsub(/\s+/, ' ')
      end

      # Codename
      #
      def codename=(codename)
        codename = codename.to_s if Symbol === codename
        Valid.oneline!(codename, :codename)
        @codename = codename.to_str
      end

      # Summary is sanitized to only have one line of text.
      #
      def summary=(summary)
        Valid.string!(summary, :summary)
        @summary = summary.to_str.gsub(/\s+/, ' ')
      end

      #
      # Sets the version of the project.
      #
      # @param [Hash<Integer>, String] version
      #   The version from the metadata file.
      #
      # @raise [ValidationError]
      #   The version must either be a `String` or a `Hash`.
      #
      def version=(version)
        case version
        when Version::Number
          @version = version
        when Hash
          major = version['major'] || version[:major]
          minor = version['minor'] || version[:minor]
          patch = version['patch'] || version[:patch]
          build = version['build'] || version[:build]
          @version = Version::Number.new(major,minor,patch,build)
        when String
          @version = Version::Number.parse(version.to_s)
        when Array
          @version = Version::Number.new(*version)
        else
          raise(ValidationError,"version must be a Hash or a String")
        end
      end

      #
      # Sets the production date of the project.
      #
      # @param [String,Date,Time,DateTime] date
      #   The production date this version.
      #
      def date=(date)
        @date = \
          case date
          when String
            Date.parse(date)
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
        @created = \
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
        @copyrights = \
          case copyrights
          when String
            [Copyright.parse(copyrights)]
          when Hash
            [Copyright.parse(copyrights)]
          when Array
            copyrights.map do |copyright|
              Copyright.parse(copyright)
            end
          else
            raise(ValidationError, "copyright must be a String, Hash or Array")
          end
      end

      #
      # Singular form of `#copyrights=`. This is similar to `#copyrights=`
      # but expects the parameter to represent only one copyright.
      #
      def copyright=(copyright)
        @copyrights = [Copyright.parse(copyright)]
      end

      # Set the authors of the project.
      #
      # @param [Array<String>, String] authors
      #   The originating authors of the project.
      #
      def authors=(authors)
        @authors = (
          list = Array(authors).map do |a|
                   Author.parse(a)
                 end
          warn "Duplicate authors listed" if list != list.uniq
          list
        )
      end

      # Sets the require paths of the project.
      #
      # @param [Array<String>, String] paths
      #   The require-paths or a glob-pattern.
      #
      #--
      # TODO: should we warn if directory does not exist?
      #++
      def load_path=(paths)
        @load_path = \
          Array(paths).map do |path|
            Valid.path!(path)
            path
          end
      end

      # List of language engine/version family supported.
      def engines=(value)
        @engines = (
          a = [value].flatten
          a.each{ |x| Valid.oneline!(x) }
          a
        )
      end

      # List of platforms supported.
      def platforms=(value)
        @platform = (
          a = [value].flatten
          a.each{ |x| Valid.oneline!(x) }
          a
        )
      end

      #
      # Sets the requirements of the project. Also commonly refered
      # to as dependencies.
      #
      # @param [Array<Hash>, Hash{String=>Hash}, Hash{String=>String}] requirements
      #   The requirement details.
      #
      # @raise [ValidationError]
      #   The requirements must be an `Array` or `Hash`.
      #
      def requirements=(requirements)
        case requirements
        when Array, Hash
          @requirements.clear
          requirements.each do |specifics|
            @requirements << Requirement.parse(specifics)
          end
        else
          raise(ValidationError,"requirements must be an Array or Hash")
        end
      end

      #
      # Binary pacakge dependecies.
      #
      # @param [Array<Hash>, Hash{String=>Hash}, Hash{String=>String}] requirements
      #   The dependency details.
      #
      # @raise [ValidationError]
      #   The dependencies must be an `Array` or `Hash`.
      #
      def dependencies=(dependencies)
        case dependencies
        when Array, Hash
          @dependencies.clear
          dependencies.each do |specifics|
            @dependencies << Dependency.parse(specifics)
          end
        else
          raise(ValidationError,"dependencies must be an Array or Hash")
        end
      end

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
      # @todo lets get rid of the type check here and let the #parse method do it
      def conflicts=(conflicts)
        case conflicts
        when Array, Hash
          @conflicts.clear
          conflicts.each do |specifics|
            @conflicts << Conflict.parse(specifics)
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

        @alternatives.clear

        alternatives.to_ary.each do |name|
          @alternatives << name.to_s
        end
      end

      #
      # Sets the packages this package is intended to usurp.
      # 
      # @param [Array<String>] replacements
      #   The replacements for the project.
      #
      def replacements=(replacements)
        Valid.array!(replacements, :replacements)

        @replacements.clear

        replacements.to_ary.each do |name|
          @replacements << name.to_s
        end
      end

      # Suite must be a single line string.
      def suite=(value)
        Valid.oneline!(value, :suite)
        @suite = value
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
          @repositories.clear
          repositories.each do |specifics|
            repo = Repository.parse(specifics)
            @repositories[repo.id] = repo
          end
        else
          raise(ValidationError, "repositories must be an Array or Hash")
        end
      end

      # Resources map <code>name => URL</code>.
      #
      # @param [Hash] resources
      #   An indexed list of resources.
      #
      def resources=(resources)
        @resources = Resources.new(resources)
      end

      # Set the orgnaization to which the project belongs.
      #
      # @param [String] organization
      #   The name of the organization.
      #
      def organization=(organization)
        Valid.oneline!(organization)
        @organization = organization
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
        @install_message = \
          case message
          when Array
            message.join($/)
          else
            Valid.string!(message)
            message.to_str
          end
      end

      # Set extraneous developer-defined metdata.
      #
      def extra=(extra)
        unless extra.kind_of?(Hash)
          raise(ValidationError, "extra must be a Hash")
        end
        @extra = extra
      end

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
        requirements << Requirement.parse(name, specifics)
      end

      #
      # Adds a new dependency.
      #
      # @param [String] name
      #   The name of the dependency.
      #
      # @param [Hash] specifics
      #   The specifics of the dependency.
      #
      def add_dependency(name, specifics)
        dependencies << Dependency.parse(name, specifics)
      end

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
        conflicts << Requirement.parse(name, specifics)
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
      # Adds a new replacement.
      #
      # @param [String] name
      #   The name of the replacement.
      #
      def add_replacement(name)
        replacements << name.to_s
      end

      #
      #
      def add_repository(id, url, scm=nil)
        @repositories << Repository.parse(:id=>id, :url=>url, :scm=>scm)
      end

      # A specification is not valid without a name and version.
      #
      # @return [Boolean] valid specification?
      def valid?
        return false unless name
        return false unless version
        true
      end

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


      # -- Calculations -------------------------------------------------------

      #
      # The primary copyright of the project.
      #
      # @return [String]
      #   The primary copyright for the project.
      #
      def copyright
        @copyrights.join("\n")
      end

      #
      # The primary email address of the project. The email address
      # is taken from the first listed author.
      #
      # @return [String, nil]
      #   The primary email address for the project.
      #
      def email
        authors.first['email']
      end

      #
      # Returns the runtime requirements of the project.
      #
      # @return [Array<Requirement>] runtime requirements.
      def runtime_requirements
        requirements.select do |requirement|
          requirements.runtime?
        end
      end

      #
      #
      #
      # @return [Array<Dependency>] runtime dependencies.
      def runtime_dependencies
        dependecies.select do |dependency|
          dependency.runtime?
        end
      end

      #
      # Returns the development requirements of the project.
      #
      # @return [Array<Requirement>] development requirements.
      #
      def development_requirements
        requirements.select do |requirement|
          ! requirements.runtime?
        end
      end

      #
      # Returns the development dependencies of the project.
      #
      # @return [Array<Dependency>] development dependencies.
      def development_dependencies
        dependecies.select do |dependency|
          ! dependency.runtime?
        end
      end

      # -- Aliases ------------------------------------------------------------

      #
      #
      # @return [Array] load paths
      def require_paths
        @load_path
      end

      #
      # RubyGems term for #load_path.
      #
      def require_paths=(value)
        self.load_path = value
      end

      #
      # Alternate short name for #replacements.
      #
      def replaces=(value)
        self.replacements = value
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
      def to_h
        # TODO: should this be the same as to_data? which makes hashes all the way down,
        # to should to_h be a shollow to_h?
      end

      # FIXME: This needs to generate the canonical form.
      #
      def to_data
        data = {}

        instance_variables.each do |iv|
          name = iv.to_s.sub(/^\@/, '')
          data[name] = send(name)
        end

        data['version']      = version.to_s

        data['date']         = date.strftime('%Y-%m-%d') if date
        data['created']      = date.strftime('%Y-%m-%d') if created

        data['authors']      = authors.map{ |a| a.to_h }
        data['requirements'] = requirements.map{ |r| r.to_h }
        data['replacements'] = replacements.to_a
        data['conflicts']    = conflicts.map{ |c| c.to_h }

        data
      end

      protected

        #
        # Initializes the {Metadata} attributes.
        #
        def initialize_attributes
          @authors               = []
          @copyrights            = []
          @replacements          = []
          @alternatives          = []
          @requirements          = []
          @dependencies          = []
          @conflicts             = []

          @repositories          = {}
          @resources             = {}
          @extra                 = {}

          @load_path             = ['lib']
        end

    end

  end

end
