## Indexer::Metadata#initialize

### Bare Instance

A Metadata object can be created using the typical `#new` class method.

    metadata = Indexer::Metadata.new

As we are testing current revision, so we can see that the revision is set
to `Indexer::REVISION` which alays holds the current revision number, which
is always the year the revision was froozen.

    metadata.revision.should == Indexer::REVISION

In addition, certain attributes will have default values.

    metadata.copyrights.should   == []
    metadata.authors.should      == []
    metadata.requirements.should == []
    metadata.dependencies.should == []
    metadata.conflicts.should    == []
    metadata.repositories.should == []
    #metadata.resources.should   == []

    metadata.load_path.should    == ['lib']

### Metadata Arguments

A Metadata object can be created with initial values by passing a metadata
hash to the initializer.

    metadata = Indexer::Metadata.new(:name=>'foo', :version=>'0.1.2')

    metadata.name.should == 'foo'
    metadata.version.to_s.should == '0.1.2'

Entries passed to the initializer are assigned via Spec's setters
and are validated upon assignment, so no invalid values can get into the
object's state, e.g.

    expect Indexer::ValidationError do
      Indexer::Metadata.new(:name=>1)
    end

### Metadata Block

Metadata can also take a block which is yeilded on `self`.

    metadata = Indexer::Metadata.new do |m|
      m.name    = 'foo'
      m.version = '0.1.2'
    end

### Initial Validity 

The only way for a Metadata object to be in an invalid state is
by the creation of an instance without providing a `name` and `version`.
Both name and version are required for a specification to be valid.

    metadata = Indexer::Metadata.new

    metadata.refute.valid?

All other fields can be `nil` or the default values automatically assigned
as shown above.

