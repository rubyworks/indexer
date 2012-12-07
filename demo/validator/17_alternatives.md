## Validator#alternatives

The `alternatives` field holds a list of other packages with which this
package can act as a substitue and vice-versa. It might also represent
the natural successor of a given package.

The format of the field is an array.

    data = Indexer::Validator.new

    data.alternatives = ['BlueCloth','rdiscount']

The `alternatives` field can only by assigned an array.

    no 100
    no :symbol
    no "string"
    no Object.new

