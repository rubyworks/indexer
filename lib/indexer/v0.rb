module Indexer

  # First revision of ruby metadata specification.
  module V0
  end

end

require_relative 'v0/attributes'
require_relative 'v0/conversion'
require_relative 'v0/canonical'
require_relative 'v0/conventional'
require_relative 'v0/author'
require_relative 'v0/copyright'
require_relative 'v0/conflict'
require_relative 'v0/resource'
require_relative 'v0/repository'
require_relative 'v0/requirement'
require_relative 'v0/dependency'
require_relative 'v0/metadata'
require_relative 'v0/validator'

