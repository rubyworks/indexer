module DotRuby

  module Version

    # The Constraint class models a single version equality or inequality.
    # It consists of the operator and the version number.
    #--
    # TODO: Please improve me!
    #
    # TODO: This should ultimately replace the class methods of Version::Number.
    #
    # TODO: Do we need to support version "from-to" spans ?
    #++
    class Constraint

      #
      def self.parse(constraint)
        new(constraint)
      end

      #
      def self.[](operator, number)
        new([operator, number])
      end

      #
      def initialize(constraint)
        @operator, @number = parse(constraint || '0+')

        case constraint
        when Array
          @stamp = "%s %s" % [@operator, @number]
        when String
          @stamp = constraint || '0+'
        end
      end

      # Verison number.
      attr :number

      # Constraint operator.
      attr :operator

      #
      def to_s
        @stamp
      end

      # Converts the version into a constraint string recognizable
      # by RubyGems.
      #--
      # TODO: Better name Constraint#to_s2.
      #++
      def to_gem_version
        op = '~>' if operator == '=~'
        "%s %s" % [operator, number]
      end

      #
      def to_proc
        lambda do |t|
          n = Version::Number.parse(t)
          n.send(operator, number)
        end
      end

    private

      #
      def parse(constraint)
        case constraint
        when Array
          op, num = constraint
        when /^(.*?)\~$/
          op, val = "=~", $1
        when /^(.*?)\+$/
          op, val = ">=", $1
        when /^(.*?)\-$/
          op, val = "<", $1
        when /^(=~|~>|<=|>=|==|=|<|>)?\s*(\d+(:?[-.]\w+)*)$/
          if op = $1
            op = '=~' if op == '~>'
            op = '==' if op == '='
            val = $2.split(/\W+/)
          else
            op = '=='
            val = constraint.split(/\W+/)
          end
        else
          raise ArgumentError #constraint.split(/\s+/)
        end
        return op, Version::Number.new(val)
      end

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
