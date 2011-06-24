## Spec#initialize

### Bare Instance

An bare Spec object can be created by passing no arguments
to the initializer.

    spec = DotRuby::Spec.new

In this case the revision number will be set to the latest available.

    spec.revision.should == DotRuby::CURRENT_REVISION

In addition, certain attributes will have default values.

    spec.licenses.should     == []
    spec.replacements.should == []
    spec.authors.should      == []
    spec.maintainers.should  == []
    spec.requirements.should == []
    spec.dependencies.should == []
    spec.conflicts.should    == []

    spec.resources.should    == {}
    spec.repositories.should == {}
    spec.extra.should        == {}

    spec.load_path.should    == ['lib']

### Spec Arguments

A Spec object can be created with initial values by passing a spec
hash to the initializer.

    spec = DotRuby::Spec.new(:name=>'foo', :version=>'0.1.2')

    spec.name.should == 'foo'
    spec.version.should == '0.1.2'

Entries passed to the initializer are assigned via Spec's setters
and are validated upon assignment, so no invalid values can get into the
object's state, e.g.

    expect DotRuby::ValidationError do
      DotRuby::Spec.new(:name=>1)
    end

### Spec Block

Spec can also take a block which is yeilded on `self`.

    spec = DotRuby::Spec.new do |spec|
      spec.name    = 'foo'
      spec.version = '0.1.2'
    end


### Initial Validity 

The only way for a Spec object to be in an invalid state is
by the creation of an instance without providing a `name` and `version`.
Both name and version are required for a specification to be valid.

    spec = DotRuby::Spec.new

    spec.refute.valid?

All other fields can be `nil` or the default values automatically assigned
as shown above.

