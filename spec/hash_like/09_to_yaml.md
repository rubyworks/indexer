## HashLike#to_yaml

    class X
      include DotRuby::HashLike
      attr_accessor :a
      def initialize(a)
        @a = a
      end
    end

    yaml = X.new(1).to_yaml

    # becuase Syck puts in a space that Psych does not
    yaml = yaml.sub('--- ','---').strip

    yaml.should == "---\na: 1\n"


