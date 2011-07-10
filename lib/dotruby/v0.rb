# These requirements are is a specific order to
# allow subclasses access to their parent classes.
if RUBY_VERSION > '1.9'
  require_relative 'v0/attributes'
  require_relative 'v0/validator'
  require_relative 'v0/specification'
  require_relative 'v0/author'
  require_relative 'v0/copyright'
  require_relative 'v0/conflict'
  require_relative 'v0/resources'
  require_relative 'v0/repository'
  require_relative 'v0/requirement'
  require_relative 'v0/dependency'
else
  require 'dotruby/v0/attributes'
  require 'dotruby/v0/validator'
  require 'dotruby/v0/specification'
  require 'dotruby/v0/author'
  require 'dotruby/v0/copyright'
  require 'dotruby/v0/conflict'
  require 'dotruby/v0/resources'
  require 'dotruby/v0/repository'
  require 'dotruby/v0/requirement'
  require 'dotruby/v0/dependency'
end

