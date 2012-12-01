## Version::Number#prerelease?

The `prerelease?` method returns `true` if the build is `pre`,
otherwise `false`.

    v = Indexer::Version::Number[1,2,3,'pre',4]

    v.assert.prerelease?


    v = Indexer::Version::Number[1,2,3]

    v.refute.prerelease?


    v = Indexer::Version::Number[1,2,3,'alpha']

    v.refute.prerelease?

