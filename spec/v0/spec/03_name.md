## Indexer::V0::Metadata#name

A valid `name` is a word starting with a letter, ending with a letter or number
and containing only `a-z`, `A-Z`, `0-9` and `_` or `-` characters.

Examples of good @names are:

    - good
    - good_too
    - good-too
    - good2

To verify this we can assign each name.

    metadata = Indexer::V0::Metadata.new

    @names.each do |name|
      metadata.name = name
    end

And these are not good @names:

     - not good
     - not,good
     - good___
     - good-

Likewise, we can verify this by trying to assign each name.

    metadata = Indexer::V0::Metadata.new

    @names.each do |name|
      expect Indexer::ValidationError do
        metadata.name = name
      end
    end

