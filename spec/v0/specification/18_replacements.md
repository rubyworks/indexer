## Spec#replacements

The `replacements` field holds a list of packages for which this package
is a natural successor. This is useful to other. An good example is 
the `gash`, the author of which is now recommedning people switch to
`grit`. So the .ruby file for `grit` could list `gash`. This is very
much akin to alternatives, but expresses a more direct relationship
of succession.

The format of the field is an array.

    spec = DotRuby::Spec.new

    spec.replacements = ['gash']

The Spec class allows any object that responds to #to_ary to be
assinged.

    o = Object.new

    def o.to_ary
      ['gash']
    end

    spec.replacements = o

But the elements must be String, or respond to `#to_str`.

    # TODO: write this demonstration

The `replacements` field cannote be assigned anyting else.

    check "invalid date" do |d|
      ! DotRuby::ValidationError.raised? do
        spec.replacements = d
      end
    end

    no 100
    no :symbol
    no "string"
    no Object.new

