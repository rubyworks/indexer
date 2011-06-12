# Spec#maintainers

The `maintainers` field holds a list of current mantainers of a project/package.

    spec = DotRuby::Spec.new

    spec.maintainers = [
      { 'name'  => 'Bob Saline',
        'email' => 'bob@mail.com',
        'team'  => ['development']
      },
      { 'name'  => 'John Delight',
        'email' => 'dlite@mail.com',
        'team'  => ['testing', 'documentation']
      }
    ]

But it also can handle and Array of Arrays. The order of the inner array
is `name, email, website, *teams`. Only `name` is not optional.

    spec.maintainers = [
      ['Bob Saline', 'bob@mail.com', 'development'],
      ['John Delight', 'dlite@mail.com', 'testing', 'documentation']
    ]


