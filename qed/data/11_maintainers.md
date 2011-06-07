# Data#maintainers

The `maintainers` field holds a list of current mantainers of a project/package.

    data = DotRuby::Data.new

    data.maintainers = [
      { 'name'  => 'Bob Sawyer',
        'email' => 'bob@mail.com',
        'team'  => ['development']
      },
      { 'name'  => 'John Delight',
        'email' => 'dlite@mail.com',
        'team'  => ['testing', 'documentation']
      }
    ]

