## Resources#to_hash

The `to_hash` method

    r = Resources.new(
      :home => 'http://foo.com'
    )

    r.to_hash.should == {
      :home => 'http://foo.com'
    }

