# These requirements are in a some what specific order
# to allow subclasses access to their parent classes.
if RUBY_VERSION > '1.9'
  require_relative 'v0/attributes'
  require_relative 'v0/conversion'
  require_relative 'v0/canonical'
  require_relative 'v0/conventional'
  require_relative 'v0/author'
  require_relative 'v0/copyright'
  require_relative 'v0/conflict'
  require_relative 'v0/resources'
  require_relative 'v0/repository'
  require_relative 'v0/requirement'
  require_relative 'v0/dependency'
else
  require 'metaspec/v0/attributes'
  require 'metaspec/v0/conversion'
  require 'metaspec/v0/canonical'
  require 'metaspec/v0/conventional'
  require 'metaspec/v0/author'
  require 'metaspec/v0/copyright'
  require 'metaspec/v0/conflict'
  require 'metaspec/v0/resources'
  require 'metaspec/v0/repository'
  require 'metaspec/v0/requirement'
  require 'metaspec/v0/dependency'
end

