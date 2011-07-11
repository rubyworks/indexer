## Author#initialize

The constructor takes a hash of entries. Recognized entries
are `name`, `email`, `website` and `role`.

    author = DotRuby::V0::Author.new(
      :name    => 'Thomas T. Thomas',
      :email   => 'tom@mail.com',
      :website => 'http://tom.com',
      :role    => 'development'
    )

DotRuby uses a dynamically module to allow revisioned components
to be tested with a non-revisioned "tag ancestor".

    author.assert.kind_of?(DotRuby::Author)

The tag module can be used as a factory for creating a new 
revisioned component.

