# Validator#authors

The `authors` field holds a list of orginating authors.

    data = Indexer::V0::Validator.new

    data.authors = [
      { 'name'  => 'Bob Sawyer',
        'email' => 'bob@mail.com'
      },
      { 'name'  => 'John Delight',
        'email' => 'dlite@mail.com'
      }
    ]

