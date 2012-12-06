## Indexer::Metadata#date

The `date` field is the date the `.ruby` file was last edited, or if
part of a package when the package was built.

This field must be a string that comforms to the ISO UTC timstamp standard.
The format of which is "YYYY-MM-DD HH:MM:SS", wheret the time portion is
optional.

    spec = Indexer::Metadata.new
    spec.date = "2011-10-20"
    spec.date = "2011-10-01 09:42:11"
    spec.date = "2011-10-01 14:42:11"

Or, the assinged value can be a Date, Time, or DateTime object.

    spec.date = Date.new
    spec.date = Time.new
    spec.date = DateTime.new

String values with invalid datetimes will raise an error, as will other
type of objects.

    check "invalid date" do |d|
      ! Indexer::ValidationError.raised? do
        spec.date = d
      end
    end

    no "2011-50-01 09:42:11"
    no 100
    no :symbol
    no Object.new

