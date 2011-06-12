## Spec#summary

The `summary` field is used to breifly describe a project.

    spec = DotRuby::Spec.new

    spec.summary = "Convenient Way to Say Hello"

The `summary` value MUST have only one line of text.

    expect DotRuby::InvalidMetaspec do
      spec.summary = "not\none\nline"
    end

The summary can be assigned with any object that responds to #to_s.

    spec.summary = :even_a_symbol


TODO: Should a summary have a size limit?

TODO: Should a summary not allow puncutation marks on the first character?

