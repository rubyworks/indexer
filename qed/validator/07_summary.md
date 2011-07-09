## Data#summary

The `summary` field is used to breifly describe a project.

    data = DotRuby::Data.new

    data.summary = "Convenient Way to Say Hello"

The `summary` value MUST have only one line of text.

    expect DotRuby::ValidationError do
      data.summary = "not\none\nline"
    end

TODO: Should a summary have a size limit?

TODO: Should a summary not allow puncutation marks on the first character?

