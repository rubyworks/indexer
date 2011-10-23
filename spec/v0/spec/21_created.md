## Spec#created

The `created` field is the date the project was started.

This field must be a string that comforms to the ISO UTC timstamp standard.
The format of which is "YYYY-MM-DD HH:MM:SS", wheret the time portion is
optional.

    spec = Spec.new
    spec.created = "2011-10-20"
    spec.created = "2011-10-01 09:42:11"
    spec.created = "2011-10-01 14:42:11"

Or, the assinged value can be a Date, Time, or DateTime object.

    spec.created = Date.new
    spec.created = Time.new
    spec.created = DateTime.new

String values with invalid datetimes will raise an error, as will other
type of objects.

    check "invalid date" do |d|
      ! DotRuby::ValidationError.raised? do
        spec.created = d
      end
    end

    no "2011-50-01 09:42:11"
    no 100
    no :symbol
    no Object.new

