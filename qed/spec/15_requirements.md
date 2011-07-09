## Spec#requirements

The `requirements` field is a list of packages which are required
to use this application/library.

The canonical field value is an Array of Hashes. The format of the
`requirements` fields is:

    requirements:
      - name: foo
        version: 1.0+
        development: false
        groups:
          - doc
        repository:
          type: git
          url: http://foo.com/foo.git
      - name: bar
        version: ~> 2.1
        :
      :

Only `name` and `version` are required sub-fields.

    spec = DotRuby::Spec.new

    spec.requirements = [
      {'name'=>'foo', 'version'=>'1.0+'},
      {'name'=>'bar', 'version'=>'1.1~', 'development'=>true, 'groups'=>['doc']}
    ]

The Spec class allows some flexibilty in defining requirements. For instance each
entry can be a string in the format of `name [constraint] [(group...)]`.

    spec = DotRuby::Spec.new

    spec.requirements = [
      'foo >= 1.0',
      'bar 1.1~ (doc)'
    ]

In the case of a string, if any group is given, the requirement is taken to
be a development requirement.

    spec.requirements[1].assert.development?

The exact interface to `Requirement.new` is `(name, specifics)` so
array elements of this king can be used as well.

    spec = DotRuby::Spec.new

    spec.requirements = [
      ['foo', {'version'=>'>= 1.0'} ],
      ['bar', {'version'=>'1.1~', 'groups'=>['doc']} ]
    ]

And combinations of all these can be used.

    spec = DotRuby::Spec.new

    spec.requirements = [
      'foo =1.2.3',
      ['bar', {'version'=>'1.1~', 'groups'=>['doc']} ]
    ]

### Hash

For simple requirements a hash can also be used.

    spec = DotRuby::Spec.new

    spec.requirements = {
      'foo' => '>= 1.0',
      'bar' => '1.1~'
    }

More complex hashes can be used as well.

    spec = DotRuby::Spec.new

    spec.requirements = {
      'foo' => {'version'=>'>= 1.0'},
      'bar' => {'version'=>'1.1~', 'groups'=>['doc']}
    }

