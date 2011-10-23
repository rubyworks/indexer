## Resources#to_hash

The `to_hash` method

    r = V0::Resources.new(
      :home => 'http://foo.com'
    )

    r.to_hash.should == {
      :home => 'http://foo.com'
    }

