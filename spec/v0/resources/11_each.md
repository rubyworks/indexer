## Resources#each

The `to_hash` method

    r = V0::Resources.new(
      :home => 'http://foo.com',
      :work => 'http://foo.com/office'
    )

    a = []

    r.each{ |k,v| a << [k,v] }

    a.assert.include? [:home, 'http://foo.com']
    a.assert.include? [:work, 'http://foo.com/office']
    a.size.assert == 2

Resources is Enumerable, so methods like #map also work.

    a = r.map{ |k,v| [k,v] }

    a.assert.include? [:home, 'http://foo.com']
    a.assert.include? [:work, 'http://foo.com/office']
    a.size.assert == 2

