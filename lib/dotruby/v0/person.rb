module DotRuby
  module V0
    # Person class is used to model Authors and Maintainers.
    #
    class Person

      # Parse `entry` and create Person object.
      def self.parse(entry)
        case entry
        when Person
          entry
        when String
          parse_string(entry)
        when Array
          case entry.size
          when 3
            new(:name=>entry[0],:email=>entry[1],:website=>entry[3])
          when 2
            new(:name=>entry[0],:email=>entry[1])
          when 1
            parse_string(entry[0])
          else
            raise ArgumentError
          end
        when Hash
          new(entry)
        end
      end

      #
      def self.parse_string(string)
        if md = /(.*?)\s*\<(.*?)\>/.match(string)
          new(:name=>md[1], :email=>md[2])
        else
          new(:name=>string)
        end
      end

      #
      def initialize(settings)
        settings.each do |field, value|
          send("#{field}=", value)
        end
        #raise ArgumentError, "person must have a name" unless name
      end

      #
      attr :name

      #
      def name=(name)
        @name = name.to_str
      end

      #
      attr :email

      #
      def email=(email)
        @email = Valid.email!(email)
      end

      #
      attr :website

      #
      def website=(website)
        @website = Valid.url!(website)
      end

      #
      def to_h
        {'name'=>name, 'email'=>email, 'website'=>website}
      end

      # CONSIDE: Only name has to be equal?
      def ==(other)
        return false unless Person === other
        return false unless name == other.name
        return true
      end
    end
  end
end
