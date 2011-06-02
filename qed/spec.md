# Spec

Spec models the explicit definition of the .ruby specification.

A blank Spec object can be created.

    spec = DotRuby::Spec.new

In this case the revision number will be set to the latest available.

    spec.revision.should == 0

In addition, certain attributes will have default values.

    spec.licenses.should     == []
    spec.requires.should     == []
    spec.conflicts.should    == []
    spec.replaces.should     == []

    spec.authors.should      == {}
    spec.maintainers.should  == {}
    spec.resources.should    == {}
    spec.repositories.should == {}
    spec.extra.should        == {}

    spec.loadpath.should     == ['lib']

## Valid Settings

A valid name is a word containing only `a-z`, `A-Z`, `0-9` and `_` or `-`.

    spec.name = "good"

    expect DotRuby::InvalidMetadata do
      spec.name = "not good"
    end

