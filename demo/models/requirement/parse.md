## Requirement#parse

The `parse` method

    r = Requirement.parse('foo 1.0+')

    expect Indexer::ValidationError do
      V0::Requirement.parse('---')
    end

    expect Indexer::ValidationError do
      V0::Requirement.parse(1)
    end

    expect Indexer::ValidationError do
      V0::Requirement.parse([1])
    end

