require 'indexer/cli'

module Indexer

  #
  #
  class CLI::Source < CLI

    #
    attr_accessor :stdout

    #
    def initialize
      @stdout = false
    end

    #
    def parse(opts)
      opts.banner = "Usage: #{$0} [options]"
      opts.on('-o', '--stdout', 'output to stdout instead of file') do
        @stdout = true
      end
    end

    #
    def run
      metadata = Indexer.import(*argv)
      if stdout
        puts metadata.to_yaml
      else
        metadata.save!  # TODO: Make sure only save when different.
      end
    end

  end

end
