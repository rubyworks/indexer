## Requirement#to_h

The `to_h` method

    r = V0::Requirement.new('foo')
    r.to_h.should == {'name' => 'foo'}

    r = V0::Requirement.new('foo', :version => '~> 1.0.0')
    r.to_h.should == {'name' => 'foo', 'version' => '~> 1.0.0'}

