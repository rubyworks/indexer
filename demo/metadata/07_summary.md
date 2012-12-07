## Indexer::Metadata#summary

The `summary` field is used to breifly describe a project.

    spec = Indexer::Metadata.new

    spec.summary = "Convenient Way to Say Hello"

The `summary` value will have all newline and multiple space characters
removed.

    spec.summary = "not\none\t  line"
    spec.summary.assert == "not one line"

The summary can be assigned only object's that responds to #to_str.

    expect Indexer::ValidationError do
      spec.summary = :even_a_symbol
    end

TODO: Should a summary have a size limit?

TODO: Should a summary not allow puncutation marks on the first character?

