## Indexer::Metadata#method_missing

To facilitate additonal uses beyond the well defined specification,
the Metadata class is open to store extraneous information that
a project developer may want to provide in the `.index` that is
not supported by the specification. Besides personal usecases,
it might also serve as a way to explore new specification fields
for the future. 

Note that the value of the field can only be a Numeric or String,
or an Array or Hash or the same.

    data = Indexer::Metadata.new

    data.notify = 'bob@gmail.com'

We can see that the arbitrary field has been set.

    data.notify.should == 'bob@gmail.com'

Anything else will raise a `ValidationError` exception.

    check do |obj|
      ! Indexer::ValidationError.raised? do
        data.notify = obj
      end
    end

    no :symbol
    no Object.new

