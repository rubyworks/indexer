## Data#name

A valid `name` is a word starting with a letter, ending with a letter or number
and containing only `a-z`, `A-Z`, `0-9` and `_` or `-` characters.

Examples of good @names are:

    `good`
    `good_too`
    `good-too`
    `good2`

To verify this we can assign each name.

    data = DotRuby::Data.new

    @names.split("\n").each do |name|
      data.name = name.strip[1..-2]
    end

And these are not good @names:

     `not good`
     `not,good`
     `good___`
     `good-`

Likewise, we can verify this by trying to assign each name.

    data = DotRuby::Data.new

    @names.split("\n").each do |name|
      expect DotRuby::InvalidMetadata do
        data.name = name.strip[1..-2]
      end
    end

