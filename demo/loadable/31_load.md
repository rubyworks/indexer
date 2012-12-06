## Metadata.load

Given a `metadata.yml` file:

    ---
    name: foo
    version: 1.0.0
    copyright: 2010 T. J. Hooker
    require_paths: ['lib', 'vendor/ansi/lib']

Then `Metadata.load('metadata.yaml')` will read in a file, parse it and
return a new Metadata object.

    metadata = Indexer::Metadata.load(File.new('metadata.yml'))

And we can verify it was read.

    metadata.name.should == 'foo'
    metadata.version.should.to_s == '1.0.0'

    metadata.copyrights.first.year   == '2010'
    metadata.copyrights.first.holder == 'T. J. Hooker'

    metadata.require_paths.should == ['lib', 'vendor/ansi/lib']

