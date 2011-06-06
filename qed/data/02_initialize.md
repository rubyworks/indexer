## Data#initialize

### Bare Instance

An bare Data object can be created by passing no arguments
to the initializer.

    data = DotRuby::Data.new

In this case the revision number will be set to the latest available.

    data.revision.should == DotRuby::CURRENT_REVISION

In addition, certain attributes will have default values.

    data.licenses.should     == []
    data.replacements.should == []
    data.authors.should      == []
    data.maintainers.should  == []

    data.requirements.should == {}
    data.conflicts.should    == {}
    data.resources.should    == {}
    data.repositories.should == {}
    data.extra.should        == {}

    data.load_path.should    == ['lib']

### Data Argument

A Data object can be created with initial values by passing a data
hash to the initializer.

    data = DotRuby::Data.new(:name=>'foo', :version=>'0.1.2')

    data.name.should == 'foo'
    data.version.should == '0.1.2'

Entries passed to the initializer are assigned via Data's setters
and are validated upon assignment, so no invalid values can get into the
object's state, e.g.

    expect DotRuby::InvalidMetadata do
      DotRuby::Data.new(:name=>1)
    end

### Initial Validity 

The only way for a Data object to be in an invalid state is
by the creation of an instance without providing a `name` and `version`.
Both name and version are required for a specification to be valid.

    data = DotRuby::Data.new

    data.refute.valid?

All other fields can be `nil` or the default values automatically assigned
as shown above.

