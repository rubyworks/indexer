module DotRuby

  module Version

    #--
    # TODO: Please improve me!
    #
    # TODO: This should ultimately replace the class methods of Version::Number.
    #
    # TODO: Do we need to support version "from-to" spans ?
    #++
    class Constraint

      # Verison number.
      attr :number

      # Constraint operator.
      attr :operator

      #
      def initialize(constraint)
        @constraint = constraint || '0+'
        @operator, @number = *parse(@constraint)
      end

      # Converts the version into a constraint recognizable by RubyGems.
      def constraint
        @constraint
      end

      #
      def parse(constraint)
        case constraint
        when /^(.*?)\~$/
          ["~>", $1]
        when /^(.*?)\+$/
          [">=", $1]
        when /^(.*?)\-$/
          ["<", $1]
        else
          constraint.split(/\s+/)
        end
      end

      #
      def to_s
        "#{constraint}"
      end

    private

      # Parse package entry into name and version constraint.
      #def parse(package)
      #  parts = package.strip.split(/\s+/)
      #  name = parts.shift
      #  vers = parts.empty? ? nil : parts.join(' ')
      # [name, vers]
      #end

    end

  end

end
