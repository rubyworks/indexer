module DotRuby

  # Current revision of specification.
  CURRENT_REVISION = 0

  #
  def self.v(revision=nil)
    const_get("V#{revision || CURRENT_REVISION}")
  end

end

require 'yaml'

require 'dotruby/exceptions/invalid_metadata'
require 'dotruby/exceptions/invalid_version'

require 'dotruby/hash_like'
require 'dotruby/spec'
require 'dotruby/metadata'
require 'dotruby/version/number'
require 'dotruby/version/constraint'

require 'dotruby/v0'

