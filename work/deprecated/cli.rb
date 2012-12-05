require 'indexer'
require 'optparse'

module Indexer

  #
  # Base CLI class.
  #
  class CLI

    def self.execute
      new.execute
    end

    def argv
      ARGV
    end

    def parse(parser)
    end

    def run
    end

    def execute
      begin
        parse_options
        run
      rescue => error
        raise error if $DEBUG
        $stderr.puts "#{error}"
        exit -1
      end
    end

  private

    def parse_options
      parser = OptionParser.new

      parse(parser)

      parser.on_tail('--debug', "display debugging information") do
        $DEBUG = true
      end

      parser.on_tail('--help', '-h', "display this help message") do
        puts parser
        exit 0
      end

      parser.parse!
    end

=begin
    #
    # Command line interface.
    #
    # To write a subcommand for `rumble` simply create an executable script
    # with the name `rumble-{name}`.
    #
    def main(*argv)
      first = argv.first
      if first && !first.start_with?('-')
        cmd = argv.shift
        require_command(cmd)
        CLI.__send__("run_#{cmd}", *argv)
      else
        if Metadata.exists?
          meta = Metadata.open
          puts meta.about
        else
          $stderr.puts "No metadata file found."
        end
      end
    rescue => error
      if $DEBUG
        raise error
      else
        $stderr.puts "#{error}"
        exit -1
      end
    end
=end

  end

end

