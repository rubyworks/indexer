## Specification#initialize

### Bare Instance

A Specification object can be created using the typical `#new` class method.

    spec = Spec.new

As we are testing revision 0, and have included the `V0` module into the 
testing namespace, we can see that the revision is set to `0`.

    spec.revision.should == 0

In addition, certain attributes will have default values.

    spec.copyrights.should   == []
    spec.authors.should      == []
    spec.requirements.should == []
    spec.dependencies.should == []
    spec.conflicts.should    == []
    spec.repositories.should == []

    #spec.resources.should    == {}
    spec.extra.should        == {}

    spec.load_path.should    == ['lib']

### Spec Arguments

A Spec object can be created with initial values by passing a spec
hash to the initializer.

    spec = Spec.new(:name=>'foo', :version=>'0.1.2')

    spec.name.should == 'foo'
    spec.version.to_s.should == '0.1.2'

Entries passed to the initializer are assigned via Spec's setters
and are validated upon assignment, so no invalid values can get into the
object's state, e.g.

    expect Indexer::ValidationError do
      Spec.new(:name=>1)
    end

### Spec Block

Spec can also take a block which is yeilded on `self`.

    spec = Spec.new do |spec|
      spec.name    = 'foo'
      spec.version = '0.1.2'
    end

### Initial Validity 

The only way for a Spec object to be in an invalid state is
by the creation of an instance without providing a `name` and `version`.
Both name and version are required for a specification to be valid.

    spec = Spec.new

    spec.refute.valid?

All other fields can be `nil` or the default values automatically assigned
as shown above.

