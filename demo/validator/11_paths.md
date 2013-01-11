## Validator#paths

The `paths` field is a means by which a project's paths can be
designated. This example a Ruby developer can use it to specify
the locations within the project that Ruby's load system should
look for files when `#require` or `#load` are used.

The `paths` value MUST be a Hash of String mapped to an Array of String.

    ok 'lib' => ['lib', 'ext']

    no 100
    no :symbol
    no "string"
    no Object.new
    no ['lib']

By default the value is `{'lib' => ['lib'] }`.

    data = Indexer::Validator.new
    data.paths.should = { 'lib' => ['lib'] }

