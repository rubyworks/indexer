## Spec#licenses

The `licenses` field is a list of license names.

    spec = DotRuby::Spec.new

    spec.licenses = ['GPL3', 'MIT', 'Apache 2.0']

The first license listed MUST be the project's primary license.

The Spec class allows the license to be assigned with any object that responds
to `#to_a`.

    spec.licenses = {['GPL3', 'MIT', 'Apache 2.0']

It will also flatten the result.

    spec.licenses = [['GPL3', 'MIT'], ['Apache 2.0']]
    spec.licenses.should == ['GPL3', 'MIT' 'Apache 2.0']


