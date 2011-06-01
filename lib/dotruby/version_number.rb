module DotRuby

  # Represents a standard three-number version.
  #
  # @see http://semver.org/
  #
  # TODO: Maybe Use POM's VersionNumber class instead as it is more feature rich.
  class VersionNumber

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
    def initialize(major,minor,patch,build=nil)
      @major = (major || 0)
      @minor = (minor || 0)
      @patch = (patch || 0)
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
      [major, minor, patch, build].compact.join('.')
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
      str = "#{@major}.#{@minor}.#{@patch}"
      str << ".#{@build}" if @build

      return str.to_yaml(io)
    end

  end

end
