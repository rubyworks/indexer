## Validator#extra

The `extra` field is used to store extraneous information that
a project developer may want to provide in the `.ruby` that is
not supported by the specification. Besides personal usecases,
it might also serve as a safe place to explore new specification
fields for the future. On the whole, it is not likely to be used
much at all, but is made available for the rare case.

The `extra` field is simply a Hash.

    data = Validator.new

    data.extra.should == {}

It can only be assigned a Hash.

    data.extra = {'notify'=>'bob@gmail.com'}

Anything else will raise an `InvalidMetadata` exception.

    no 100
    no :symbol
    no Object.new

