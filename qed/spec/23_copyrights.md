## Spec#copyright

The `copyright` field is a free-form string desingated for used
to provide a copyright notice.

    spec = DotRuby::Data.new

    spec.copyright = "Copyright (c) 2010 T. Bone Willy"

The copyright string can have multiple lines.

    spec.copyright = %{
      Copyright (c) 2010 T. Bone Willy
      Copyright (c) 2010 J. Horn Silly
    }

But it can only be a string.

    no []
    no 100
    no :symbol
    no Object.new

The field has no other restrictions, but as a matter of proper use it SHOULD
not contain license disclamers --that is the domain of a README, COPYING or
a similar file.

The usecase for this field is to output a copyright notice for a command
line `--version` inquery, or on a pop-up About window.

