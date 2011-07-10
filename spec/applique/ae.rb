require 'ae/should'

#
# Copy and paste for now, b/c lib is not mature.
#

#require 'ae/ok'  # /check ?

def check(msg=nil, &block)
  if block.arity == 0
    @__c__ = nil
    assert(block.call, msg)
  else
    @__c__ = [block, msg]
  end
end

def ok(*args)
  block, message = *@__c__
  result = block.call(*args)
  assert(result, message)
end

def no(*args)
  block, message = *@__c__
  begin
    result = block.call(*args)
  rescue Exception => error
    #if error.respond_to?(:assertion?) && error.assertion?
      true
    #else
    #  raise error
    #end
  end
  refute(result, message)
end

