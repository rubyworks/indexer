module Indexer

  # First revision of ruby metadata specification.
  module V2013
  end

end

require_relative 'v2013/attributes'
require_relative 'v2013/conversion'
#require_relative 'v2013/canonical'
#require_relative 'v2013/conventional'
require_relative 'v2013/author'
require_relative 'v2013/copyright'
require_relative 'v2013/conflict'
require_relative 'v2013/resource'
require_relative 'v2013/repository'
require_relative 'v2013/requirement'
require_relative 'v2013/dependency'
require_relative 'v2013/metadata'
require_relative 'v2013/validator'

