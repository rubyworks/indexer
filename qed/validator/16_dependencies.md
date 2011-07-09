## Validator#dependencies

The `dependencies` field is a list of *binary* packages which are required
to use this application/library.

The field value is an Array of Hashes. The format of the `dependencies`
fields is:

    dependencies:
      - name: foo
        version: 1.0+
        development: false
        group:
          - doc
        repo:
          type: git
          url: http://foo.com/foo.git
      - name: bar
        version: ~> 2.1
        :
      :

Only `name` and `version` are required sub-fields.

    data = DotRuby::Validator.new

    data.dependencies = [
      {'name'=>'foo', 'version'=>'1.0+'},
      {'name'=>'foo', 'version'=>'1.0+', 'development'=>true, 'group'=>['doc']}
    ]

