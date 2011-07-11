## Spec#version

The Spec class can hande 
The `version` field follows closely to the SemVer[http://semiver.org] standard.

    check "version validation error" do |v, r|
      spec = Specification.new
      spec.version = v
      spec.version.to_a.should == r
    end

### String

    ok "1.2.3",       [1,2,3]
    ok "1.2.3.pre.4", [1,2,3,'pre',4]
    ok "1.2.3.pre4",  [1,2,3,'pre',4]
    ok "1.2.3pre4",   [1,2,3,'pre',4]

### Hash

    ok( {:major=>1, :minor=>2, :patch=>3},                 [1,2,3]         )
    ok( {:major=>1, :minor=>0, :patch=>1, :build=>'pre3'}, [1,0,1,'pre',3] )

    ok( {'major'=>1, 'minor'=>5, 'patch'=>1},              [1,5,1]         )

### Array

    ok [1, 2, 3],          [1, 2, 3]
    ok [1, 2, 3, 'rc', 4], [1, 2, 3, 'rc', 4]


