## Author#initialize

The constructor takes a hash of entries. Recognized entries
are `name`, `email`, `website` and `role`.

    author = Author.new(
      :name    => 'Thomas T. Thomas',
      :email   => 'tom@mail.com',
      :website => 'http://tom.com',
      :role    => 'development'
    )

We should be able to query the author object for the various settings.

    author.name     #=> 'Thomas T. Thomas'
    author.email    #=> 'tom@mail.com'
    author.website  #=> 'http://tom.com'
    author.roles    #=> ['development']

