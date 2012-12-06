## Validator#codename

The `codename` field is used to name the specific version.

    data = Indexer::Validator.new
    data.codename = "Lazy Louse"

The `codename` value MUST have only one lone of text.

    expect Indexer::ValidationError do
      data.codename = "foo\nbar"
    end

TODO: Should a codename have a size limit?

TODO: Should a codenmae not allow puncutation marks on the first character?

