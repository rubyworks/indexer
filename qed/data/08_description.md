## Data#description

The `description` field is used to describe a project in detail.
It SHOULD be a single paragraph.

    data = DotRuby::Data.new

    data.description = "HelloWorld is the best way to say hello.\nJust say it!"

While description has no specific size limit, it SHOULD be less than 1,000
characters.

