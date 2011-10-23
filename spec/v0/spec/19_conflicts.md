## Spec#conflicts

The `conflicts` field holds a list of packages with which the project is
known not to be compatible.

The format of the field is a mapping to package names indexing version
constraints.

    spec = Spec.new

    spec.conflicts = {
       'bad_robot' => '>=1.0',
       'evil' => '0+'
    }

The conflicts fields also accepts an array of strings.

    spec.conflicts = [
      'bad_robot >=1.0',
      'evil 0+'
    ]

Or an array of hash entries.

    spec.conflicts = [
      {:name => 'bad_robot', :version => '>=1.0'},
      {:name => 'evil', :version => '0+' }
    ]

The `conflicts` field can only by assigned such a Hash.

    check "invalid conflict" do |d|
      ! DotRuby::ValidationError.raised? do
        spec.conflicts = d
      end
    end

    no 100
    no :symbol
    no Object.new


