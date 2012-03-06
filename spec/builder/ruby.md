# Ruby

Builder can create a DotRuby Spec via method_missing.

    builder = DotRuby::Builder.new

    builder.name 'example'

    builder.authors 'trans <transfire@gmail.com>',
                    'postmodern'

So then

    spec = builder.spec

    spec.name.assert == 'example'

    spec.authors.size == 2

The Ruby-based builder module uses this fact whe loading Ruby-based
sources.

