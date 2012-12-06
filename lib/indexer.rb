module Indexer
  # Current stable revision of the specification (by year).
  REVISION = 2013

  # File name of locked metadata file.
  LOCK_FILE = '.index'

  # Default metadata file for use by end-developer.
  USER_FILES = '{Indexfile,Indexfile.rb,Metadata,Metadata.yml,Metadata.yaml}'

  # Indexer library directory.
  LIBDIR = File.dirname(__FILE__) + '/indexer'

  # Indexer library directory.
  DATADIR = File.dirname(__FILE__) + '/../data/indexer'
end

require 'yaml'
require 'time'

require 'indexer/version/exceptions'
require 'indexer/version/number'
require 'indexer/version/constraint'

require 'indexer/core_ext'
require 'indexer/command'

require 'indexer/error'
require 'indexer/valid'

require 'indexer/loadable'
require 'indexer/revision'
require 'indexer/model'
require 'indexer/models'
require 'indexer/importer'

#require 'indexer/gemfile'

