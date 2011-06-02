# CanonicalMetadata

CanonicalMetadata models the explicit definition of the .ruby specification.

A blank CanonicalMetadata object can be created.

    metadata = DotRuby::CanonicalMetadata.new

In this case the revision number will be set to the latest available.

    metadata.revision.should == 0

In addition, certain attributes will have default values.

    metadata.licenses.should     == []
    metadata.requires.should     == []
    metadata.conflicts.should    == []
    metadata.replaces.should     == []

    metadata.authors.should      == {}
    metadata.maintainers.should  == {}
    metadata.resources.should    == {}
    metadata.repositories.should == {}
    metadata.extra.should        == {}

    metadata.loadpath.should     == ['lib']

## Valid Settings

A valid name is a word containing only `a-z`, `A-Z`, `0-9` and `_` or `-`.

    metadata.name = "good"

    expect DotRuby::InvalidMetadata do
      metadata.name = "not good"
    end

