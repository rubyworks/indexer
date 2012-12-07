## Validator#organizations

The `organizations` field holds a list of the company, club, foundation,
or programming groups involved with a project. For users of GitHub this
will most likey be the GitHub organization in which a project is hosted.

    data = Indexer::Validator.new

    data.organizations = [
      { 'name'  => 'Bobs Compnay',
        'email' => 'bobinc@mail.com',
        'roles' => ['sponsers']
      },
      { 'name'  => 'Johns Programming Club',
        'email' => 'dlite@mail.com'
      }
    ]


