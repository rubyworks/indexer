## Spec#dependencies

The `dependencies` field is essentially the same as `requirements` except that
it is a list of *binary* packages which are required of the opersating system.

The canonical field value is an Array of Hashes. The format of the
`dependencies` fields is:

    dependencies:
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

    spec = Specification.new

    spec.dependencies = [
      {'name'=>'foo', 'version'=>'1.0+'},
      {'name'=>'bar', 'version'=>'1.1~', 'development'=>true, 'groups'=>['doc']}
    ]

The Spec class allows some flexibilty in defining dependencies. For instance each
entry can be a string in the format of `name [constraint] [(group...)]`.

    spec = Specification.new

    spec.dependencies = [
      'foo >= 1.0',
      'bar 1.1~ (doc)'
    ]

In the case of a string, if any group is given, the requirement is taken to
be a development requirement.

    spec.dependencies[1].assert.development?

The exact interface to `Requirement.new` is `(name, specifics)` so
array elements of this king can be used as well.

    spec = Specification.new

    spec.dependencies = [
      ['foo', {'version'=>'>= 1.0'} ],
      ['bar', {'version'=>'1.1~', 'groups'=>['doc']} ]
    ]

And combinations of all these can be used.

    spec = Specification.new

    spec.dependencies = [
      'foo =1.2.3',
      ['bar', {'version'=>'1.1~', 'groups'=>['doc']} ]
    ]

### Hash

For simple dependencies a hash can also be used.

    spec = Specification.new

    spec.dependencies = {
      'foo' => '>= 1.0',
      'bar' => '1.1~'
    }

More complex hashes can be used as well.

    spec = Specification.new

    spec.dependencies = {
      'foo' => {'version'=>'>= 1.0'},
      'bar' => {'version'=>'1.1~', 'groups'=>['doc']}
    }

