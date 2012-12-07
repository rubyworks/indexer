module Indexer
  # Name of this program.
  NAME = 'indexer'

  # Current stable revision of the specification (by year).
  REVISION = 2013

  # File name of locked metadata file.
  LOCK_FILE = '.index'

  # Default metadata file name for use by end-developer.
  USER_FILES = '{Indexfile,Indexfile.rb,Metadata,Metadata.yml,Metadata.yaml}'

  # Indexer library directory.
  LIBDIR = File.dirname(__FILE__) + '/indexer'

  # Indexer library directory.
  DATADIR = File.dirname(__FILE__) + '/../data/indexer'

  # Project metadata via RubyGems, fallback to .index file.
  def self.const_missing(name)
    name = name.to_s.downcase
    begin
      Gem.loaded_specs[NAME].send(name).to_s
    rescue StandardError
      file = File.join(File.dirname(__FILE__), '..', '.index')
      if File.exist?(file)
        require 'yaml'
        data = YAML.load_file(file)
        data[name]        
      end
    end
  end
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
require 'indexer/revision'

require 'indexer/model'
require 'indexer/components'
require 'indexer/metadata'
require 'indexer/importer'

