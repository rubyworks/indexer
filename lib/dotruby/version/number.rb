module DotRuby

  module Version

    # Represents a standard three-number version.
    #
    # @see http://semver.org/
    #
    # TODO: Maybe Use POM's VersionNumber class instead as it is more feature rich.
    class Number

      # Major version number
      attr_reader :major

      # Minor version number
      attr_reader :minor

      # Patch version number
      attr_reader :patch

      # The build string
      attr_reader :build

      #
      # Creates a new version.
      #
      # @param [Integer, nil] major
      #   The major version number.
      #
      # @param [Integer, nil] minor
      #   The minor version number.
      #
      # @param [Integer, nil] patch
      #   The patch version number.
      #
      # @param [Integer, nil] build (nil)
      #   The build version number.
      #
      def initialize(major=0,minor=0,patch=0,build=nil)
        @major = major
        @minor = minor
        @patch = patch
        @build = build
      end

      #
      # Parses a version string.
      #
      # @param [String] string
      #   The version string.
      #
      # @return [Version]
      #   The parsed version.
      #
      def self.parse(string)
        major, minor, patch, build = string.split('.',4)

        return self.new(
          (major || 0).to_i,
          (minor || 0).to_i,
          (patch || 0).to_i,
          build
        )
      end

      #
      # Converts the version to a String.
      #
      def to_s
        str = "#{@major}.#{@minor}.#{@patch}"
        str << ".#{@build}" if @build

        return str
      end

      #
      # Converts the version to YAML.
      #
      # @param [IO] io
      #   The output stream to write to.
      #
      # @return [String]
      #   The resulting YAML.
      #
      def to_yaml(io)
        to_s.to_yaml(io)
      end

      def stable_release?
        @build.nil?
      end

      def pre_release?
        !@build.nil?
      end

      def ==(other)
        unless self.class === other 
          other = self.class.parse(other)
        end
        (@major == other.major) && \
          (@minor == other.minor) && \
          (@patch == other.patch) && \
          (@build == other.build)
      end

      def <=>(other)
        if @major > other.major
          1
        elsif @major < other.major
          -1
        elsif @minor > other.minor
          1
        elsif @minor < other.minor
          -1
        elsif @patch > other.patch
          1
        elsif @patch < other.patch
          -1
        elsif (@build && other.build.nil?)
          -1
        elsif (@build.nil? && other.build)
          1
        elsif @build > other.build
          1
        elsif @build < other.build
          -1
        else
          0
        end
      end

    end

  end

end
