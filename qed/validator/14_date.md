## Data#date

The `date` field is the date the .ruby file was last edited, or if
part of a package when the package was built. This field
must be a string that comforms to the ISO UTC timstamp standard.
The format of which is "YYYY-MM-DD HH:MM:SS". The time portion is
optional.

    ok "2011-10-20"
    ok "2011-10-01 09:42:11"
    ok "2011-10-01 14:42:11"

Invalid dates and times will be rejected.

    no "2011-50-01 09:42:11"
    no "2011-10-01 99:42:11"

As will anything other than a string.

    no 100
    no :symbol
    no Object.new
    no Date.new
    no Time.new

