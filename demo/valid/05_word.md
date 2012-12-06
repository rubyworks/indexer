## Valid.word? / word!

A valid word is String with no whitepsace characters, including
new lines. It must start with a letter and can only contain
characters /[A-Z][a-z]_-/.

### word?

    check "word" do |word|
      Indexer::Valid.word?(word)
    end

These are all valid words.

    ok "good"
    ok "still_good"
    ok "still-good"
    ok "good1"

And these are not valid words.

    no "not good"
    no "not\ngood"
    no "not\tgood"
    no "1notgood"

### word!

    check do |word|
      ! Indexer::ValidationError.raised? do
        Indexer::Valid.word!(word)
      end
    end

Again, these are all valid words.

    ok "good"
    ok "still_good"
    ok "still-good"
    ok "good1"

And these are not valid words.

    no "not good"
    no "not\ngood"
    no "not\tgood"
    no "1notgood"

