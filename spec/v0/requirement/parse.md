## Requirement#parse

The `parse` method

    r = V0::Requirement.parse('foo 1.0+')

    expect DotRuby::ValidationError do
      V0::Requirement.parse('---')
    end

    expect DotRuby::ValidationError do
      V0::Requirement.parse(1)
    end

    expect DotRuby::ValidationError do
      V0::Requirement.parse([1])
    end

