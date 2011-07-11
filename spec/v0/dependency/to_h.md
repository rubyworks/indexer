## Dependency#to_h

The `to_h` method

    r = Dependency.new('foo')
    r.to_h.should == {'name' => 'foo'}

    r = Dependency.new('foo', :version => '~> 1.0.0')
    r.to_h.should == {'name' => 'foo', 'version' => '~> 1.0.0'}

