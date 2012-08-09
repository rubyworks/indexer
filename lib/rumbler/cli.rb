module Rumbler

  require 'optparse'  # load OptionParser library

  # CLI is a self extend module.
  #
  module CLI
    extend self

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
          meta = Metadata.find
          puts meta.about
        else
          $stderr.puts "No metadata file found."
        end
      end
    end

    # 
    # Require command script. This allows rumble to support
    # command plugins.
    # 
    def require_command(cmd)
      cmd = 'generate' if cmd == 'gen'
      begin
        require "rumbler/cli/#{cmd}"
      rescue LoadError
      end
    end

  end

end

