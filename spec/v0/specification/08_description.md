## Spec#description

The `description` field is used to describe a project in detail.
It SHOULD be a single paragraph.

    spec = Specification.new

    spec.description = "HelloWorld is the best way to say hello.\nJust say it!"

While description has no specific size limit, it SHOULD be less than 1,000
characters.

The Spec class allows any object that responds to #to_s to be assigned to
the `description` field.

    spec.description = :even_a_symbol


