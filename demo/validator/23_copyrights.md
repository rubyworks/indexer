## Validator#copyright

The `copyrights` field is a sequence of mappings providing the copyright
and license information.

License values SHOULD be identifiers from SPDX.

    data = Indexer::Validator.new

    data.copyrights = [
      { 'year'    => '2010',
        'holder'  => 'T. Bone Willy',
        'license' => 'MIT'
      },
      { 'year'    => '2011',
        'holder'  => 'J. Horn Silly',
        'license' => 'GPL-3.0'
      }
    ]

And it can be no tother type of object.

    no 100
    no :symbol
    no Object.new

The field has no other restrictions, but as a matter of proper use it SHOULD
not contain license disclamers --that is the domain of a README, COPYING or
a similar file.

The usecase for this field is to output a copyright notice for a command
line `--version` inquery, or on a pop-up About window.

