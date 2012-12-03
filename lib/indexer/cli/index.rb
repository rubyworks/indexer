require 'indexer/cli'

module Indexer

  #
  #
  #
  class CLI::Index < CLI

    #
    def initialize
      @verbose = false
    end

    #
    def parse(opts)
      opts.banner = "Usage: #{$0} [options] [source ...]"
      opts.on_tail('--debug', 'run with $DEBUG set to true') do
        $DEBUG = true
      end
      opts.on_tail('-h', '--help', 'read this help message') do
        puts opts
        exit
      end
    end

    #
    def run
      Metadata.ensure_locked

      if Metadata.exists?
        metadata = Metadata.open
        puts metadata.about(*argv)
      else
        raise Error.exception(".index file not found", IOError)
      end
    end

  end

end
