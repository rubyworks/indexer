## Validator#alternatives

The `alternatives` field holds a list of other packages with which this
package can act as a substitue and vice-versa.

The format of the field is an array.

    data = DotRuby::Validator.new

    data.alternatives = ['BlueCloth','rdiscount']

The `alternatives` field can only by assigned an array.

    no 100
    no :symbol
    no "string"
    no Object.new

