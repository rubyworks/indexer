## Spec#copyright

The `copyrights` field is a list of copyright and licens information.

    spec = DotRuby::Spec.new

The copyright list is canonically a mapping.

    spec.copyrights = [
      { 'year'    => '2010',
        'holder'  => 'T. Bone Willy',
        'license' => 'MIT'
      },
      { 'year'    => '2011',
        'holder'  => 'J. Horn Silly',
        'license' => 'GPL-3.0'
      }
    ]

The copyrights can also be given as strings.

    spec.copyrights = [
      "Copyright (c) 2010 T. Bone Willy (MIT)",
      "Copyright (c) 2010 J. Horn Silly (GPL-3.0)"
    ]

Or as a single string, for which there is a singular alias.

    spec.copyright = "Copyright (c) 2010 T. Bone Willy"

But it can't be any other value.

    no 100
    no :symbol
    no Object.new

The field has no other restrictions, but as a matter of proper use it SHOULD
not contain license disclamers --that is the domain of a README, COPYING or
a similar file.

The usecase for this field is to output a copyright notice for a command
line `--version` inquery, or on a pop-up About window.

