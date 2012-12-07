## Indexer::Metadata#load_path

The `load_path` field is the means by which a developer instructs
Ruby's load system of the locations within the project to look for
files when `#require` or `#load` are used.

The `load_path` value MUST be an Array of String.

    spec = Indexer::Metadata.new
    spec.load_path = ['lib', 'ext']

Or any object that responds to `#to_ary`.

    o = Object.new

    def o.to_ary
      ['lib', 'ext']
    end

    spec.load_path = o

It can also take a string path.

    spec.load_path = "foo/path"
    spec.load_path.assert == ["foo/path"]

Any other object will cause an error.

    check "invalid load_path" do |d|
      ! Indexer::ValidationError.raised? do
        spec.load_path = d
      end
    end

    no 100
    no :symbol
    no Object.new

The elements must also be valid path strings.

    no [100, 200]

By default the value, when no load_path is set, is `['lib']`.

    spec = Indexer::Metadata.new
    spec.load_path.should = ['lib']

