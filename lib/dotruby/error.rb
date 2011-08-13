module DotRuby
  # Tag module for DotRuby Exceptions.
  #
  # Use this module to extend arbitrary errors raised by DotRuby,
  # so they can be easily identified as DotRuby errors if need be. 
  module Error
    # Just catch the error and raise this instead.
    def self.exception(msg=nil,orig=$!)
      if Class === orig
        orig = orig.new(msg)
      elsif orig.nil?
        orig = StandardError.new(msg)
      else
        orig.message = msg if msg
      end
      orig.extend self
      orig
    end
  end
end

