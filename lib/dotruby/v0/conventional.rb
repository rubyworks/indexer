module DotRuby

  module V0

    # Conventional readers and writers provide various conveniences
    # for working with metadata.
    module Conventional

      # Sets the name of the project.
      #
      # @param [String] name
      #   The new name of the project.
      #
      def name=(name)
        @name = name.to_s
      end

      #
      # Sets the version of the project.
      #
      # @param [Hash<Integer>, String] version
      #   The version from the metadata file.
      #
      # @raise [InvalidMetadata]
      #   The version must either be a `String` or a `Hash`.
      #
      def version=(version)
        case version
        when VersionNumber
          @version = version
        when Hash
          major = version['major']
          minor = version['minor']
          patch = version['patch']
          build = version['build']

          @version = VersionNumber.new(major,minor,patch,build)
        when String
          @version = VersionNumber.parse(version.to_s)
        else
          raise(InvalidMetadata,"version must be a Hash or a String")
        end
      end

      #
      # Sets the production date of the project.
      #
      # @param [String] date
      #   The production date this version.
      #
      def date=(date)
        @date = case date
                when String
                  Date.parse(date)
                else
                  date
                end
      end

      #
      # Sets the creation date of the project.
      #
      # @param [String] date
      #   The creation date of this project.
      #
      def created=(date)
        @date = case date
                when String
                  Date.parse(date)
                else
                  date
                end
      end

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
      # Sets the license(s) of the project.
      #
      # @param [Array, String] license
      #   The license(s) of the project.
      #
      def licenses=(licenses)
        @licenses = [licenses].flatten
      end

      #
      # Singular alias for #licenses=.
      alias :licence= :licenses=

      #
      # Sets the authors of the project.
      #
      # @param [Array<String>, String] authors
      #   The originating authors of the project.
      #
      # TODO: if an entry is just a string convert it to a hash.
      def authors=(authors)
        @authors = case authors
                   when Array
                     authors
                   else
                     [authors]
                   end
      end

      #
      # Sets the maintainers of the project.
      #
      # @param [Array<String>, String] maintainer
      #   The current maintainers of the project.
      #
      #--
      # TODO: if an entry is just a string convert it to a hash.
      #++
      def maintainers=(maintainers)
        @maintainers = case manitainers
                       when Array
                         maintainers
                       else
                         [maintainers]
                       end
      end

      #
      # The primary email address of the project. The email address
      # is taken from the first listed maintainer.
      #
      # @return [String, nil]
      #   The primary email address for the project.
      #
      def email
        @maintainers.first['email']
      end

      #
      # Sets the require-paths of the project.
      #
      # @param [Array<String>, String] paths
      #   The require-paths or a glob-pattern.
      #
      def require_paths=(paths)
        @require_paths = each_path(paths).to_a
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
      def message=(message)
        @message = case message
                   when Array
                     message.join($/)
                   else
                     message.to_s
                   end
      end

      #
      # Sets the packages with which this package is known to have
      # incompatibilites.
      #
      # @param [Array, String] replacements
      #   The conflicts for the project.
      #
      def conflicts=(conflicts)
        unless conflicts.kind_of?(Hash)
          raise(InvalidMetadata, "conflicts must be a Hash")
        end

        @conflicts.clear

        conflicts.each do |name, specifics|
          add_conflict(name, specifics)
        end
      end

      #
      # Sets the packages this package could (more or less) replace.
      # 
      # @param [Array, String] replacements
      #   The replacements for the project.
      #
      def replacements=(replacements)
        unless replacements.kind_of?(Hash)
          raise(InvalidMetadata, "replacements must be a Hash")
        end

        @replacements.clear

        replacements.each do |name, specifics|
          add_replacement(name, specifics)
        end
      end

      #
      # Alternate short name for #replacements.
      #
      alias :replaces= :replacements=

      #
      # Sets the requirements of the project. Also commonly refered
      # to as dependencies.
      #
      # @param [Hash{String => String}] requirements
      #   The dependency names and specifics.
      #
      # @raise [InvalidMetadata]
      #   The requirements must be a `Hash`.
      #
      def requirements=(requirements)
        unless requirements.kind_of?(Hash)
          raise(InvalidMetadata, "requirements must be a Hash")
        end

        @requirements.clear

        requirements.each do |name, specifics|
          add_requirement(name, specifics)
        end
      end

      #
      # Alternate short name for #requirements.
      #
      alias :requires= :requirements=

      #
      # Common alias for #requirements.
      #
      alias :dependencies= :requirements=

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
        @requirements << Requirement.parse(name, specifics)
      end

      #
      # Adds a new replacement.
      #
      # @param [String] name
      #   The name of the replacement.
      #
      # @param [Hash] specifics
      #   The specifics of the replacement.
      #
      def add_replacement(name, specifics)
        @replacements << Requirement.parse(name, specifics)
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
        @conflicts << Requirement.parse(name, specifics)
      end

      #
      # Returns the runtime requirements of the project.
      #
      # @return [Array<Requirement>] runtime requirements.
      #
      def runtime_requirements
        requirements.select do |requirement|
          requirements.runtime?
        end
      end

      #
      #
      #
      alias :runtime_dependencies, :runtime_requirements

      #
      # Returns the development requirements of the project.
      #
      # @returns [Array<Requirement>] development requirements.
      #
      def development_requirements
        requirements.select do |requirement|
          ! requirements.runtime?
        end
      end

      #
      #
      #
      alias :development_dependencies, :development_requirements

      #
      # Sets the external requirements for the project.
      #
      # External requirements are non-package requirements refering
      # instead to arbitrary resources. These might be as specific as
      # a system library such as "libXML2 1.0+", or as generic as a
      # "fast graphics card".
      #
      # @param [Array, String] requirements
      #   The external requirements for the prokect.
      #
      def exteneral_requirements=(requirements)
        @external_requirements = case requirements
                                 when Array
                                   requirements
                                 else
                                   [requirements]
                                 end
      end

=begin
      #
      # Sets the files of the project.
      #
      # @param [Array<String>, String] paths
      #   The files or the glob-pattern listed in the metadata file.
      #
      def files=(paths)
        @files = each_path(paths).to_a
      end
=end

      #
      # Set extraneous user-defined metdata.
      #
      def extra=(extra)
        unless extra.kind_of?(Hash)
          raise(InvalidMetadata, "extra must be a Hash")
        end
        @extra = extra
      end

      #
      # Convert convenience form of metadata to canonical form.
      #
      #--
      # TODO: Maybe this code should be a in different file?
      #++
      def to_canonical
        data = {}
        instance_variables.each do |iv|
          name = iv.to_s.sub(/^\@/, '')
          data[name] = send(name)
        end

        data['date']    = date.strftime('%Y-%m-%d') if date

        data['created'] = date.strftime('%Y-%m-%d') if created

        data['requirements'] = requirements.inject({}) do |h, (k,v)|
          h[k] = v.to_h
        end

        data['replacements'] = replacements.inject({}) do |h, (k,v)|
          h[k] = v.to_h
        end

        data['conflicts'] = conflicts.inject({}) do |h, (k,v)|
          h[k] = v.to_h
        end

        CanonicalMetadata.new(data)
      end

    protected

      #
      # Initializes the {Metdata} attributes.
      #
      def initialize_attributes
        @licenses              = []
        @authors               = []
        @maintatiners          = []

        @require_paths         = []

        @requirements          = []
        @replacements          = []
        @conflicts             = []
        @external_requirements = []

        #@files = []
      end

    end

  end

end
