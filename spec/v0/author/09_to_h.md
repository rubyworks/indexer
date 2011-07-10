## Author#to_h

Given a valid author instance.

    author = DotRuby::V0::Author.new(
      :name    => 'Thomas T. Thomas',
      :email   => 'tom@mail.com',
      :website => 'http://tom.com',
      :role    => 'development'
    )

The author can be converted to canonical form using #to_h.

    h = author.to_h

    h['name'].should    == 'Thomas T. Thomas'
    h['email'].should   == 'tom@mail.com'
    h['website'].should == 'http://tom.com'


