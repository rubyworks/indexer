module DotRuby
  # Current revision of specification.
  CURRENT_REVISION = 0

  # Hash which auto-loads DotRuby Versions.
  #
  # @return [Hash{Integer => Module}]
  #   The Hash of DotRuby revisions and their modules.
  #
  # TODO: Or a capitalized method?
  V = Hash.new do |hash,key|
    revision = key.to_i
    require "dotruby/v#{revision}"

    module_name = "V#{revision}"

    unless const_defined?(module_name)
      raise("unsupported .ruby version: #{revision.inspect}")
    end

    hash[key] = const_get(module_name)
  end

  #
  def self.load(path=Dir.pwd)
    if File.file?(path)
      Spec.read(path)
    else
      Spec.find(path)
    end
  end

end

require 'yaml'

require 'dotruby/cli'

require 'dotruby/error'
require 'dotruby/valid'

require 'dotruby/model'
#require 'dotruby/factories'

require 'dotruby/v0' # CURRENT_REVISION

require 'dotruby/spec'

require 'dotruby/version/exceptions'
require 'dotruby/version/number'
require 'dotruby/version/constraint'

# If we ever descide to support plugins in the future.
#require 'dotruby/plugins'
#DotRuby.load_plugins

#require 'dotruby/bundler'

