module DotRuby

  # First revision of dotruby specification.
  module V0

    #
    #
    #
    module Conventional

      # Conventional module requires Attributes module and 
      # all the modeling classes.
      if RUBY_VERSION > '1.9'
        require_relative 'attributes'
        require_relative 'requirement'
        require_relative 'dependency'
        require_relative 'conflict'
        require_relative 'person'
      else
        require 'dotruby/v0/attributes'
        require 'dotruby/v0/requirement'
        require 'dotruby/v0/dependency'
        require 'dotruby/v0/conflict'
        require 'dotruby/v0/person'
      end

      #
      #
      #
      module Writers

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
            major = version['major']
            minor = version['minor']
            patch = version['patch']
            build = version['build']

            @version = Version::Number.new(major,minor,patch,build)
          when String
            @version = Version::Number.parse(version.to_s)
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

        #
        # Sets the license(s) of the project. License entries SHOULD be well
        # recognized short-hand names such as "GPL3" and "Apache 2.0". Licenses
        # should be in order of significance. The first license given is taken
        # to be the project's primary license.
        #
        #    spec.licenses = "MIT"
        #    spec.licenses = ["GPL3", "Apache 2.0"]
        #
        # @param [Array<String>, String] licenses
        #   The license(s) of the project.
        #
        def licenses=(licenses)
          @licenses = (
            list = [licenses].flatten
            list.map!{ |s| Valid.string!(s); s.to_str }
            warn "Duplicate licenses listed" if list != list.uniq
            list.uniq
          )
        end

        #
        # Sets the authors of the project.
        #
        # @param [Array<String>, String] authors
        #   The originating authors of the project.
        #
        # @todo if an entry is just a string convert it to a hash.
        def authors=(authors)
          @authors = (
            list = case authors
                   when Array
                     authors.map{ |a| Person.parse(a) }
                   else
                     [Person.parse(authors)]
                   end
            warn "Duplicate authors listed" if list != list.uniq
            list
          )
        end

        #
        # Sets the maintainers of the project.
        #
        # @param [Array<String>, String] maintainer
        #   The current maintainers of the project.
        #
        # @todo if an entry is just a string convert it to a hash.
        def maintainers=(maintainers)
          @maintainers = (
            list = case maintainers
                   when Array
                     maintainers.map{ |m| Person.parse(m) }
                   else
                     [Person.parse(maintainers)]
                   end
            warn "Duplicate maintainers listed" if list != list.uniq
            list
          )           
        end

        #
        # Sets the require-paths of the project.
        #
        # @param [Array<String>, String] paths
        #   The require-paths or a glob-pattern.
        #
        #--
        # TODO: should we warn if directory does not exist?
        #++
        def load_path=(paths)
          @load_path = case
            when Valid.array?(paths)
              paths.to_ary.map{ |path| Valid.path!(path); path }.flatten
            when Valid.path?(paths)
              [paths]
            else
              Valid.raise_invalid('path', paths, :load_path)
            end
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

        #
        # Sets the files of the project.
        #
        # @param [Array<String>, String] paths
        #   The files or the glob-pattern listed in the metadata file.
        #
        # def files=(paths)
        #   @files = each_path(paths).to_a
        # end

        #
        # Set extraneous user-defined metdata.
        #
        def extra=(extra)
          unless extra.kind_of?(Hash)
            raise(ValidationError, "extra must be a Hash")
          end
          @extra = extra
        end

      end

      #
      #
      #
      module Utility

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

      protected

        #
        # Initializes the {Metadata} attributes.
        #
        def initialize_attributes
          @authors               = []
          #@external_requirements = []
          @licenses              = []
          @maintainers           = []
          @replacements          = []
          @alternatives          = []
          @requirements          = []
          @dependencies          = []
          @conflicts             = []

          @repositories          = {}
          @resources             = {}
          @extra                 = {}

          @load_path             = ['lib']

          #@files = []
        end

      private

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

      end

      #
      #
      #
      module Calculations

        #
        # The primary license of the project.
        #
        # @return [String, nil]
        #   The primary license for the project.
        #
        def license
          @licenses.first
        end

        #
        # The primary email address of the project. The email address
        # is taken from the first listed maintainer.
        #
        # @return [String, nil]
        #   The primary email address for the project.
        #
        def email
          maintainers.first['email']
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

      end

      #
      #
      #
      module Aliases

        #
        # Singular alias for #licenses=.
        def licence=(value)
           self.licenses = (value)
        end

        #
        #
        # @return [Array] load paths
        def require_paths
          @load_path
        end

        #
        #
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

      end

      #
      #
      #
      module Conversion

        #
        # Convert convenience form of metadata to canonical form.
        #
        def to_data
          Data.new(to_h)
        end

        #
        #
        #
        def to_h
          data = {}

          instance_variables.each do |iv|
            name = iv.to_s.sub(/^\@/, '')
            data[name] = send(name)
          end

          data['date']    = date.strftime('%Y-%m-%d') if date
          data['created'] = date.strftime('%Y-%m-%d') if created

          data['requirements'] = requirements.map do |r|
            r.to_h
          end

          data['replacements'] = replacements.to_a

          data['conflicts'] = conflicts.inject({}) do |h, (k,v)|
            h[k] = v.to_h
          end

          data
        end

      end

      include Attributes
      include Writers
      include Utility
      include Calculations
      include Aliases
      include Conversion
    end

  end

end
