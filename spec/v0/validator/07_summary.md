## Validator#summary

The `summary` field is used to breifly describe a project.

    data = Indexer::V0::Validator.new

    data.summary = "Convenient Way to Say Hello"

The `summary` value MUST have only one line of text.

    expect Indexer::ValidationError do
      data.summary = "not\none\nline"
    end

TODO: Should a summary have a size limit?

TODO: Should a summary not allow puncutation marks on the first character?

