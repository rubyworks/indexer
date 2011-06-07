## Data#conflicts

The `conflicts` field holds a list of packages with which the project is
known not to be compatible.

The format of the field is a mapping to package names indexing version
constraints.

    data = DotRuby::Data.new

    data.conflicts = {
       'bad_robot' => '>=1.0',
       'evil' => '0+'
    }

The `conflicts` field can only by assigned such a Hash.

    no 100
    no :symbol
    no Object.new

