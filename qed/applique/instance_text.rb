require 'yaml'

When /(\@\w+)/ do |iv, txt|
  instance_variable_set(iv, YAML.load(txt))
end

