## Spec.save!

Given a Spec instance.

    spec = DotRuby::Spec.new
    spec.name    = 'foo'
    spec.version = '1.0.0'

We can save the Spec to disk in canonical form using
the `#save!` method.

    spec.save!('ruby.yml')

We can us `#read` to ensure it saved as we expected.

    spec = DotRuby::Spec.read('ruby.yml')

And we can verify it was read.

    spec.name.should == 'foo'
    spec.version.should.to_s == '1.0.0'

To be even more sure let's load in the raw YAML.

    yaml = YAML.load_file('ruby.yml')

    yaml['name'].should    == 'foo'
    yaml['version'].should == '1.0.0'

Notice also that certain fields automically get defaults
values set.

    yaml['requirements'] == []
    yaml['resources']    == {}

