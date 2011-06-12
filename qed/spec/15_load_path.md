## Spec#load_path

The `load_path` field is the means by which a developer instructs
Ruby's load system of the locations within the project to look for
files when `#require` or `#load` are used.

The `load_path` value MUST be an Array of String.

    spec = DotRuby::Spec.new
    spec.load_path = ['lib', 'ext']

Or any object that responds to `#to_ary`.

    o = Object.new do
      def to_ary
        ['lib', 'ext']]
      end
    end

    spec.load_path = o

Any other object will cause an error.

    check "invalid date" do |d|
      ! DotRuby::InvalidMetadata.raised? do
        spec.load_path = d
      end
    end

    no 100
    no :symbol
    no "string"
    no Object.new

The elements must also be valid path strings.

    no [100, 200]

By default the value, when no load_path is set, is `['lib']`.

    spec = DotRuby::Spec.new
    spec.load_path.should = ['lib']

