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
      def license=(licenses)
        @licenses = [licenses].flatten
      end

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
      # TODO: if an entry is just a string convert it to a hash.
      def maintainers=(maintainers)
        @maintainers = case manitainers
                       when Array
                         maintainers
                       else
                         [maintainers]
                       end
      end

      #
      # The primary email address of the project.
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
      #
      #
      def conflicts=(conflicts)
        @replaces = case conflicts
                    when Array
                      conflicts
                    else
                      [conflicts]
                    end
      end

      #
      #
      # 
      def replaces=(replaces)
        @replaces = case replaces
                    when Array
                      replaces
                    else
                      [replaces]
                    end
      end

      #
      # Sets the external requirements of the project.
      #
      # @param [Array, String] requirements
      #   The external requirements.
      #
      def requirements=(requirements)
        @requirements = case requirements
                        when Array
                          requirements
                        else
                          [requirements]
                        end
      end

      #
      #
      alias_accessor :requires, :requirements

      #
      # Sets the dependencies of the project.
      #
      # @param [Hash{String => String}] dependencies
      #   The dependency names and versions listed in the metadata file.
      #
      # @raise [InvalidMetadata]
      #   The dependencies must be a `Hash`.
      #
      def dependencies=(dependencies)
        unless dependencies.kind_of?(Hash)
          raise(InvalidMetadata, "dependencies must be a Hash")
        end

        @dependencies.clear

        dependencies.each do |name,versions|
          add_dependency(name,versions)
        end
      end

      #
      # Adds a new runtime dependency.
      #
      # @param [String] name
      #   The name of the dependency.
      #
      # @param [Array<String>, String] versions
      #   The required versions of the dependency.
      #
      def add_runtime_dependency(name,versions)
        @runtime_dependencies << Dependency.parse(name,versions)
      end

      #
      # Sets the runtime-dependencies of the project.
      #
      # @param [Hash{String => String}] dependencies
      #   The runtime-dependency names and versions listed in the metadata
      #   file.
      #
      # @raise [InvalidMetadata]
      #   The runtime-dependencies must be a `Hash`.
      #
      def runtime_dependencies=(dependencies)
        unless dependencies.kind_of?(Hash)
          raise(InvalidMetadata,"runtime_dependencies must be a Hash")
        end

        @runtime_dependencies.clear

        dependencies.each do |name,versions|
          add_runtime_dependency(name,version)
        end
      end

      #
      # Adds a new development dependency.
      #
      # @param [String] name
      #   The name of the dependency.
      #
      # @param [Array<String>, String] versions
      #   The required versions of the dependency.
      #
      def add_development_dependency(name,versions)
        @development_dependencies << Dependency.parse(name,versions)
      end

      #
      # Sets the development-dependencies of the project.
      #
      # @param [Hash{String => String}] dependencies
      #   The development-dependency names and versions listed in the
      #   metadata file.
      #
      # @raise [InvalidMetadata]
      #   The development-dependencies must be a `Hash`.
      #
      def development_dependencies=(dependencies)
        unless dependencies.kind_of?(Hash)
          raise(InvalidMetadata,"development_dependencies must be a Hash")
        end

        @development_dependencies.clear

        dependencies.each do |name,versions|
          add_development_dependency(name,version)
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
      # Extra user-defined metdata.
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
      def to_canonical
      end

    protected

      #
      # Initializes the {Metdata} attributes.
      #
      def initialize_attributes
        @licenses    = []
        @authors     = []
        @maintatiner = []

        @require_paths = []

        @requirements = []
        @dependencies = []
        @runtime_dependencies = []
        @development_dependencies = []

        #@files = []
      end

    end

  end

end
