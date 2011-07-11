## Resources#method_missing

The `method_missing` method allows arbitrary resources
to be defined and read.

    r = Resources.new

    r.vip = 'http://foo.com/viproom'

    r.vip.should == 'http://foo.com/viproom'
