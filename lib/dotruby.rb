module DotRuby
  # Current revision of specification.
  CURRENT_REVISION = 0

  # Hash which auto-loads DotRuby Versions.
  #
  # @return [Hash{Integer => Module}]
  #   The Hash of DotRuby revisions and their modules.
  #
  V = Hash.new do |hash,key|
    revision = key.to_i
    require "dotruby/v#{revision}"

    module_name = "V#{revision}"

    unless const_defined?(module_name)
      raise("unsupported .ruby version: #{revision.inspect}")
    end

    hash[key] = const_get(module_name)
  end
end

require 'yaml'

require 'dotruby/exceptions'
require 'dotruby/valid'
require 'dotruby/hash_like'

require 'dotruby/data'
require 'dotruby/spec'

require 'dotruby/version/exceptions'
require 'dotruby/version/number'
require 'dotruby/version/constraint'
