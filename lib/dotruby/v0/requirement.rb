module DotRuby

  # Requirement class.
  #
  # QUESTION: Does Requirement really need to handle multiple version constraints?
  # Currently this only support one version constraint.
  class Requirement

    # Create new instance of Requirement.
    #
    def initialize(name, specifics={})
      @name = name.to_s

      specifics.each do |key, value|
        send("#{}=", value)
      end
    end

    #
    # Set the requirement's runtime flag.
    #
    # @param [Boolean] true/false runtime requirement
    #
    def runtime=(boolean)
      @runtime = !!boolean
    end

    #
    # Returns true if the requirement is a runtime requirement.
    #
    def runtime?
      @runtime
    end

    #
    # Set the version number.
    #
    def version=(version)
      @version = VersionNumber.parse(version)
    end

    #
    # The requirement's version number.
    #
    # @return [VersionNumber] version number.
    #
    attr :version

    #
    # Set the groups to which the requirement belongs.
    #
    # @return [Array, String] list of groups
    #
    def groups=(groups)
      @groups = [groups].flatten
    end

    #
    alias group= groups=

    #
    # The groups to which the requirement belongs.
    #
    # @return [Array] list of groups
    #
    attr :groups

  end

end
