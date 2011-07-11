## Version::Number#pre_release?

The `pre_release?` method returns `true` if the build is `pre`,
otherwise `false`.

    v = DotRuby::Version::Number[1,2,3,'pre',4]

    v.assert.pre_release?


    v = DotRuby::Version::Number[1,2,3]

    v.refute.pre_release?


    v = DotRuby::Version::Number[1,2,3,'alpha']

    v.refute.pre_release?

