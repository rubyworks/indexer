## Resources#to_h

The `to_h` method

    r = V0::Resources.new(
      :home => 'http://foo.com'
    )

    r.to_h.should == {
      'home' => 'http://foo.com'
    }


