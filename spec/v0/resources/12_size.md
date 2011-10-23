## Resources#size

The `size` method

    r = V0::Resources.new(
      :home => 'http://foo.com',
      :work => 'http://foo.com/office'
    )

    r.size.assert == 2

