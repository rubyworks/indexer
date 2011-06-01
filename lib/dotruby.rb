module DotRuby

  # Current revision of specification.
  CURRENT_REVISION = 0

  #
  def self.v(revision=nil)
    const_get("V#{revision || CURRENT_REVISION}")
  end

end

require 'dotruby/exceptions/invalid_metadata'
require 'dotruby/exceptions/invalid_version'

require 'dotruby/metadata'
require 'dotruby/canonical_metadata'
require 'dotruby/version_number'

require 'dotruby/v0'

