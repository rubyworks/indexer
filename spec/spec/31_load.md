## Spec.load

Given a `ruby.yml` file:

    ---
    name: foo
    version: 1.0.0
    copyright: 2010 T. J. Hooker
    require_paths: ['lib', 'vendor/ansi/lib']

Then `Spec.load('ruby.ayml')` will read in a file, parse it and
return a new Spec object.

    spec = DotRuby::Spec.load('ruby.yml')

And we can verify it was read.

    spec.name.should == 'foo'
    spec.version.should.to_s == '1.0.0'

    spec.copyrights.first.year   == '2010'
    spec.copyrights.first.holder == 'T. J. Hooker'

    spec.require_paths.should == ['lib', 'vendor/ansi/lib']

