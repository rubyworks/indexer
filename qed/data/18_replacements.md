## Data#replacements

The `replacements` field holds a list of packages for which this package
is the natural successor and/or API compatible (or nearly so) substitute.
A good example is `erubis` as a replacement for `erb`.

The format of the field is an array.

    data = DotRuby::Data.new

    data.replacements = ['BlueCloth','rdiscount']

The `replacementns` field can only by assigned an array.

    no 100
    no :symbol
    no "string"
    no Object.new

