## Indexer::Metadata#paths

The `paths` field is a means by which project paths can be designated.
In general, it is intended for the path keys to correspond to the FHS
(File Hierarchy Standard), although there is no absolute requirement.

For example, Ruby developer's use the `lib` entry to specify the locations
within the project that Ruby's load system should look for files when `#require`
or `#load` are used.

The `paths` value MUST be a Hash.

    spec = Indexer::Metadata.new
    spec.paths = { 'lib' => ['lib'] }

Or any object that responds to `#to_hash`.

    o = Object.new

    def o.to_hash
      { 'lib' => ['lib'] }
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

By default the value, when no paths are set, is `{ 'lib=> ['lib']}`.

    spec = Indexer::Metadata.new
    spec.paths.should = {'lib' => ['lib']}

