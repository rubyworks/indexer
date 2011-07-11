## Requirement#parse

The `parse` method

    r = Requirement.parse('foo 1.0+')

    expect DotRuby::ValidationError do
      Requirement.parse('---')
    end

    expect DotRuby::ValidationError do
      Requirement.parse(1)
    end

    expect DotRuby::ValidationError do
      Requirement.parse([1])
    end

