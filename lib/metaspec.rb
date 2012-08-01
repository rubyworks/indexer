module Meta

  # Current revision of specification.
  CURRENT_REVISION = 0

  # Hash which auto-loads Metaspec Versions.
  #
  # @return [Hash{Integer => Module}]
  #   The Hash of Metaspec revisions and their modules.
  #
  # TODO: Or a capitalized method?
  V = Hash.new do |hash,key|
    revision = key.to_i
    require "metaspec/v#{revision}"

    module_name = "V#{revision}"

    unless const_defined?(module_name)
      raise("unsupported ruby metaspec version: #{revision.inspect}")
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

require 'metaspec/cli'

require 'metaspec/error'
require 'metaspec/valid'

require 'metaspec/model'
#require 'metaspec/factories'

require 'metaspec/v0' # CURRENT_REVISION

require 'metaspec/spec'

require 'metaspec/version/exceptions'
require 'metaspec/version/number'
require 'metaspec/version/constraint'

require 'metaspec/builder'

# If we ever descide to support plugins in the future.
#require 'metaspec/plugins'
#Meta.load_plugins

#require 'metaspec/bundler'

