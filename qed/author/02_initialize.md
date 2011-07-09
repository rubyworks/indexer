## Author#initialize

The constructor takes a hash of entries. Recognized entries
are `name`, `email`, `website` and `role`.

    author = DotRuby::V0::Author.new(
      :name    => 'Thomas T. Thomas',
      :email   => 'tom@mail.com',
      :website => 'http://tom.com',
      :role    => 'development'
    )


