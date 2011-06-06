module DotRuby

  # Current revision of specification.
  CURRENT_REVISION = 0

  #
  def self.v(revision)
    module_name ="V#{revision}"

    unless const_defined?(module_name)
      raise("unsupported .ruby version: #{revision.inspect}")
    end

    const_get(module_name)
  end

end

require 'yaml'

require 'dotruby/exceptions/invalid_metadata'
require 'dotruby/exceptions/invalid_version'

require 'dotruby/hash_like'
require 'dotruby/data'
require 'dotruby/spec'
require 'dotruby/version/number'
require 'dotruby/version/constraint'

require 'dotruby/v0'

