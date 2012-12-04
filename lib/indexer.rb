module Indexer
  # Indexer library directory.
  LIBDIR = File.dirname(__FILE__) + '/indexer'

  # Indexer library directory.
  DATADIR = File.dirname(__FILE__) + '/../data/indexer'

  # Default metadata file for use by end-developer.
  USER_FILE = 'Indexfile'  # 'Metadata'

  # File name of locked metadata file.
  LOCK_FILE = '.index'

  # Current stable revision of the specification (by year).
  REVISION = 2013
end

require 'yaml'
require 'time'

require 'indexer/version/exceptions'
require 'indexer/version/number'
require 'indexer/version/constraint'

require 'indexer/cli'

require 'indexer/error'
require 'indexer/valid'

#require 'indexer/base'
require 'indexer/loadable'
require 'indexer/revisioned'
require 'indexer/factories'
require 'indexer/model'

require 'indexer/importer'
#require 'indexer/gemfile'

require 'indexer/v'
require 'indexer/v2013'  # current revision

#require 'indexer/metadata'

