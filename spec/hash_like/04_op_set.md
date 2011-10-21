## HashLike#[]=

    class X
      include DotRuby::HashLike
      attr_accessor :a
      def initialize(a)
        @a = a
      end
    end

    x = X.new(1)

    x[:a] = 2

    x.a.should == 2

If we try to set a non-existent attribute, a ArgumentError will
be raised.

    expect NoMethodError do
      x[:q] = 9
    end

