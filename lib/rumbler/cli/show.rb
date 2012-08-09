module Rumbler

  module CLI

    #
    # Show command.
    #
    def run_show(*argv)
      verbose = false
      begin
        parser = OptionParser.new do |opts|
          opts.banner = "Usage: #{$0} show [part ...]"
          opts.on_tail('--debug', 'run with $DEBUG set to true') do
            $DEBUG = true
          end
          opts.on_tail('-h', '--help', 'read this help message') do
            puts opts
            exit
          end
        end
        parser.parse!(argv)

        Metadata.ensure_locked

        if Metadata.exists?
          metadata = Metadata.open
          puts metadata.about(*argv)
        else
          raise Error.exception("no metadata file found", IOError)
        end
      rescue => error
        if $DEBUG
          raise error
        else
          $stderr.puts "#{error}"
          exit -1
        end
      end
    end

  end

end

