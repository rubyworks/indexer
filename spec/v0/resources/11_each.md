## Resources#each

The `to_hash` method

    r = Resources.new(
      :home => 'http://foo.com',
      :work => 'http://foo.com/office'
    )

    a = []

    r.each{ |k,v| a << [k,v] }

    a.assert == [
      [:home, 'http://foo.com'],
      [:work, 'http://foo.com/office']
    ]

Resources is Enumerable, so methods like #map also work.

    a = r.map{ |k,v| [k,v] }

    a.assert == [
      [:home, 'http://foo.com'],
      [:work, 'http://foo.com/office']
    ]

