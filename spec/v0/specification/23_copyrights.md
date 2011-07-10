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

It can also be given as an array of three element arrays.

    spec.copyrights = [
      ["2010", "T. Bone Willy", "BSD-2-Clause"]
    ]

    spec.copyrights[0].year.should    == "2010"
    spec.copyrights[0].holder.should  == "T. Bone Willy"
    spec.copyrights[0].license.should == "BSD-2-Clause"

The Array entry form can be used as a single assigment
on the singular method.

    spec.copyright = ["2010", "T. Bone Willy", "BSD-2-Clause"]

    spec.copyrights[0].year.should    == "2010"
    spec.copyrights[0].holder.should  == "T. Bone Willy"
    spec.copyrights[0].license.should == "BSD-2-Clause"

But not the plural.

    expect DotRuby::ValidationError do
      spec.copyrights = ["2010", "T. Bone Willy", "BSD-2-Clause"]
    end

NOTE: Maybe in the future a more intelligent parser could handle this.

But it can't be any other value.

    no 100
    no :symbol
    no Object.new

Each copyright entry can be convert to a standard copyright _stamp_ using
the `#to_s` method.

    spec.copyrights = [
      ["2010", "T. Bone Willy", "BSD-2-Clause"],
      ["2011", "J. Horn Silly", "GPL-3.0"]
    ]

    stamp = spec.copyrights.first.to_s

    stamp  #=> "Copyright (c) 2010 T. Bone Willy (BSD-2-Clause). All Rights Reserved."

The singular method #copyright will output a complete copyright statement.

    statement = spec.copyright

    statement.should = \
      "Copyright (c) 2010 T. Bone Willy (BSD-2-Clause). All Rights Reserved.\n" +
      "Copyright (c) 2011 J. Horn Silly (GPL-3.0). All Rights Reserved."

A canonical hash can be produced using #to_h.

    spec.copyrights[0].to_h.should == {
      'year'    => '2010',
      'holder'  => 'T. Bone Willy',
      'license' => 'BSD-2-Clause'
    }

The usecase for this field is to output a copyright notice for a command
line `--version` inquery, or on a pop-up About window.

