module Rumbler
  # Rumbler library directory.
  LIBDIR = File.dirname(__FILE__) + '/rumbler'

  # Rumbler library directory.
  DATADIR = File.dirname(__FILE__) + '/../data/rumbler'

  # Current stable revision.
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

require 'rumbler/v0' # CURRENT_REVISION

require 'rumbler/metadata'

