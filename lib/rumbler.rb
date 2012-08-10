module Rumbler
  # Rumbler library directory.
  LIBDIR = File.dirname(__FILE__) + '/rumbler'

  # Rumbler library directory.
  DATADIR = File.dirname(__FILE__) + '/../data/rumbler'

  # Default metadata file for use by end-developer.
  USER_FILE = 'Metadata'

  # File name of locked metadata file.
  LOCK_FILE = '.metadata.lock'

  # Current stable revision of specification.
  REVISION = 0
end

require 'yaml'
require 'time'

require 'rumbler/cli'

require 'rumbler/error'
require 'rumbler/valid'

require 'rumbler/base'
require 'rumbler/model'

require 'rumbler/version/exceptions'
require 'rumbler/version/number'
require 'rumbler/version/constraint'

require 'rumbler/builder'
#require 'rumbler/bundler'

require 'rumbler/v0'  # current revision

require 'rumbler/metadata'

