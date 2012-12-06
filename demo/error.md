## Indexer::Error

The `Indexer::Error` module is a <i>tag error</i>. It can be 
raised like any other error, but if another error has been
raised, i.e. if `$!` is set, then it will raise that error
extended by `Error` module.

    begin
      fooballs
    rescue NameError
      expect NameError do
        raise Indexer::Error
      end
    end

It can also be used to manually extend an error, in other words,
to _tag_ an error. 

    standard_error = StandardError.new
    standard_error.extend Indexer::Error

    begin
      raise standard_error
    rescue Indexer::Error => error
      assert StandardError === error
    end

This allows Indexer exceptions to identified while still fully utilizing
Ruby's exceptions system.

