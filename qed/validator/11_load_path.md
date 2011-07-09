## Validator#load_path

The `load_path` field is the means by which a developer instructs
Ruby's load system of the locations within the project to look for
files when `#require` or `#load` are used.

The `load_path` value MUST be an Array of String.

    ok ['lib', 'ext']

    no 100
    no :symbol
    no "string"
    no Object.new

By default the value is ['lib']

    data = DotRuby::Validator.new
    data.load_path.should = ['lib']

