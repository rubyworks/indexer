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

    public

      # Parses a string constraint returning the operation as a lambda.
      def self.constraint_lambda(constraint)
        op, val = *parse_constraint(constraint)
        lambda{ |t| t.send(op, val) }
      end

      # Parses a string constraint returning the operator and value.
      def self.parse_constraint(constraint)
        constraint = constraint.strip
        #re = %r{^(=~|~>|<=|>=|==|=|<|>)?\s*(\d+(:?[-.]\d+)*)$}
        re = %r{^(=~|~>|<=|>=|==|=|<|>)?\s*(\d+(:?[-.]\w+)*)$}
        if md = re.match(constraint)
          if op = md[1]
            op = '=~' if op == '~>'
            op = '==' if op == '='
            val = new(md[2].split(/\W+/))
          else
            op = '=='
            val = new(constraint.split(/\W+/))
          end
        else
          raise ArgumentError, "invalid constraint '#{constraint}'"
        end
        return op, val
      end

    end

  end

end
