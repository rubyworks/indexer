## Validator#initialize

### Bare Instance

A bare Validator object can be created by passing no arguments
to the initializer.

    data = Validator.new(:revision=>0)

    data.revision.should == 0

In addition, certain attributes will have default values.

    data.copyrights.should   == []
    data.replacements.should == []
    data.authors.should      == []
    data.requirements.should == []
    data.dependencies.should == []
    data.conflicts.should    == []

    data.resources.should    == {}
    data.repositories.should == {}
    data.extra.should        == {}

    data.load_path.should    == ['lib']

### Validator Argument

A Validator object can be created with initial values by passing a data
hash to the initializer.

    data = Validator.new(:name=>'foo', :version=>'0.1.2')

    data.name.should == 'foo'
    data.version.should == '0.1.2'

Entries passed to the initializer are assigned via Validator's setters
and are validated upon assignment, so no invalid values can get into the
object's state, e.g.

    expect DotRuby::ValidationError do
      Validator.new(:name=>1)
    end

### Initial Validity 

The only way for a Validator object to be in an invalid state is
by the creation of an instance without providing a `name` and `version`.
Both name and version are required for a specification to be valid.

    data = Validator.new

    data.refute.valid?

All other fields can be `nil` or the default values automatically assigned
as shown above.

