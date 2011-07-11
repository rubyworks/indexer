## DotRuby::Error

The `DotRuby::Error` module is a <i>tag error</i>. It can be 
raised like any other error, but if another error has been
raised, i.e. if `$!` is set, then it will raise that error
extended by `Error` module.

    begin
      fooballs
    rescue NameError
      expect NameError do
        raise DotRuby::Error
      end
    end

It can also be used to manually extend an error, in other words,
to _tag_ an error. 

    standard_error = StandardError.new
    standard_error.extend DotRuby::Error

    begin
      raise standard_error
    rescue DotRuby::Error => error
      assert StandardError === error
    end

This allows DotRuby exceptions to identified while still fully utilizing
Ruby's exceptions system.

