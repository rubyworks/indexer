module Indexer
  # Name of this program.
  NAME = 'indexer'

  # Current stable revision of the specification (by year).
  REVISION = 2013

  # File name of locked metadata file.
  LOCK_FILE = '.index'

  # Default metadata file name for use by end-developer.
  USER_FILES = '{Index,Indexfile,Metadata}{,.rb,.yml,.yaml}'

  # Indexer library directory.
  LIBDIR = File.dirname(__FILE__) + '/indexer'

  # Indexer library directory.
  DATADIR = File.dirname(__FILE__) + '/../data/indexer'

  # Metadata from the project's `indexer.yml` index file.
  # This is used as a fallback for #const_missing.
  #
  # Returns [Hash] of metadata.
  def self.index
    @index ||= (
      require 'yaml'
      dir  = File.dirname(__FILE__)
      file = Dir[File.join(dir, "{#{NAME}.yml,../.index}")].first
      file ? YAML.load_file(file) : {}
    )
  end

  # Project metadata via RubyGems, fallback to index file.
  #
  # TODO: The #to_s on the gemspec return value is a bit too simplistic. But how to fix?
  #       The goal is reduce the value to a basic type (String, Hash, Array, Numeric).
  #
  def self.const_missing(const_name)
    name = const_name.to_s.downcase
    begin
      Gem.loaded_specs[NAME].send(name).to_s
    rescue StandardError
      index[name] || super(const_name)
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

