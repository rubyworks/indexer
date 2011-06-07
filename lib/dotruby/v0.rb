if RUBY_VERSION > '1.9'
  require_relative 'v0/attributes'
  require_relative 'v0/conventional'
  require_relative 'v0/canonical'
else
  require 'dotruby/v0/attributes'
  require 'dotruby/v0/conventional'
  require 'dotruby/v0/canonical'
end

