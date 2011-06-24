module DotRuby
  # TODO: The only problm with this is that we
  # can't subclass other exceptions like `ArgumentError`.
  class Exception < RuntimeError
  end

  #
  class ValidationError < Exception #ArgumentError
  end
end

