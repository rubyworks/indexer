## Spec#alternatives

The `alternatives` field holds a list of other packages with which this
package can act as a reasonable substitue and vice-versa.

The format of the field is an array.

    spec = Spec.new

    spec.alternatives = ['BlueCloth','rdiscount']

The Spec class allows any object that responds to #to_ary to be
assinged.

    o = Object.new

    def o.to_ary
      ['BlueCloth', 'rdiscount']
    end

    spec.alternatives = o

But the elements must be String, or respond to `#to_str`.

    # TODO: write this demonstration

The `alternatives` field cannot accept anything else.

    check "invalid alternative" do |d|
      ! Indexer::ValidationError.raised? do
        spec.alternatives = d
      end
    end

    no 100
    no :symbol
    no "string"
    no Object.new

