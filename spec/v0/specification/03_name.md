## Spec#name

A valid `name` is a word starting with a letter, ending with a letter or number
and containing only `a-z`, `A-Z`, `0-9` and `_` or `-` characters.

Examples of good @names are:

    - good
    - good_too
    - good-too
    - good2

To verify this we can assign each name.

    spec = Specification.new

    @names.each do |name|
      spec.name = name
    end

And these are not good @names:

     - not good
     - not,good
     - good___
     - good-

Likewise, we can verify this by trying to assign each name.

    spec = Specification.new

    @names.each do |name|
      expect DotRuby::ValidationError do
        spec.name = name
      end
    end

