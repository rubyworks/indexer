## Validator#replacements

The `replacements` field holds a list of packages for which this package
is a natural successor. This is useful to other. An good example is 
the `gash`, the author of which is now recommedning people switch to
`grit`. So the .ruby file for `grit` could list `gash`. This is very
much akin to alternatives, but expresses a more direct relationship
of succession.

The format of the field is an array.

    data = Validator.new

    data.replacements = ['BlueCloth','rdiscount']

The `replacementns` field can only by assigned an array.

    no 100
    no :symbol
    no "string"
    no Object.new

