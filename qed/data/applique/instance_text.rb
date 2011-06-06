When /(\@\w+)/ do |iv, txt|
  instance_variable_set(iv, txt)
end

