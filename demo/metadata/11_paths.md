## Indexer::Metadata#paths

The `paths` field is a means by which a project's paths can be
designated. This example a Ruby developer can use it to specify
the locations within the project that Ruby's load system should
look for files when `#require` or `#load` are used.

The `paths` value MUST be a Hash.

    spec = Indexer::Metadata.new
    spec.paths = { 'load' => ['lib'] }

Or any object that responds to `#to_hash`.

    o = Object.new

    def o.to_hash
      { 'load' => ['lib'] }
    end

    spec.paths = o

The hash values should be arrays, but a string can be used and it
will be converted into an array.

    spec.paths = { "foo" => "foo/path" }
    spec.paths.assert == { "foo" => ["foo/path"] }

Any other object will cause an error.

    check "invalid load_path" do |d|
      ! Indexer::ValidationError.raised? do
        spec.paths = d
      end
    end

    no 100
    no :symbol
    no Object.new

The elements must also be valid path strings.

    no 'load'=>[100, 200]

By default the value, when no paths are set, is `{ 'load=> ['lib']}`.

    spec = Indexer::Metadata.new
    spec.paths.should = {'load' => ['lib']}

