module DotRuby
  # Tag module for DotRuby Exceptions.
  #
  # Use this module to extend arbitrary errors raised by DotRuby,
  # so they can be easily identified as DotRuby errors if needs be. 
  module Error
    # Just catch the error and raise this instead.
    def self.exception(msg=nil,orig=$!)
      orig.extend self
      orig
    end
  end
end

