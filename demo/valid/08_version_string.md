## Valid.version_string? / version_string!

### version_string?

  check do |str|
    Indexer::Valid.assert.version_string?(str)
  end

  ok '1.0.0'
  ok '1.0.rc.2'
  ok '1.0.x.3'

  no 'a.b.c'
  no '&'
  no 'A.0.0'

### version_string!

  check do |str|
    Indexer::Valid.version_string!(str)
  end

  ok '1.0.0'
  ok '1.0.rc.2'
  ok '1.0.x.3'

  no 'a.b.c'
  no '&'
  no 'A.0.0'

