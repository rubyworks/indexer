## Validator#requirements

The `requirements` field is a list of packages which are required
to use this application/library.

The field value is an Array of Hashes. The format of the `requirements`
fields is:

    requirements:
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

    data = Indexer::V0::Validator.new

    data.requirements = [
      {'name'=>'foo', 'version'=>'1.0+'},
      {'name'=>'foo', 'version'=>'1.0+', 'development'=>true, 'group'=>['doc']}
    ]

