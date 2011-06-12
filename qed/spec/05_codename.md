## Sped#codename

The `codename` field is used to name the specific version.

    spec = DotRuby::Spec.new
    spec.codename = "Lazy Louse"

The `codename` value MUST have only one lone of text.

    expect DotRuby::InvalidMetadata do
      spec.codename = "foo\nbar"
    end

The Spec allows any object that responds to #to_s to be assigned.

    spec.codename = :LazyLouse
    spec.codename.assert == :LazyLouse

TODO: Should a codename have a size limit?

TODO: Should a codename not allow puncutation marks on the first character?

