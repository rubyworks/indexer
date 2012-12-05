require 'indexer/cli'

module Indexer

  #
  class CLI::Show < CLI

    #
    def parse(opts)
      opts.banner = "Usage: #{$0} [options] [part ...]"
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

