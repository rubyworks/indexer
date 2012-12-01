module Indexer

  module CLI

    #
    def run_generate(*argv)
      type = argv.shift
      require_generate_command(type)
      __send__("run_generate_#{type}", *argv) 
    end

    #
    alias run_gen run_generate

    #
    def require_generate_command(type)
      require "indexer/cli/generate_#{type}"
    end

  end

end
