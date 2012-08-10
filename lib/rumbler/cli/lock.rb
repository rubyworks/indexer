module Rumbler

  module CLI

    #
    # Build locked metadata from a variety of possible sources.
    #
    def run_lock(*argv)
      stdout = false

      begin
        parser = OptionParser.new do |opts|
          opts.banner = "Usage: #{$0} [options]"
          opts.on('-o', '--stdout', 'output to stdout instead of file') do
            stdout = true
          end
          opts.on_tail('--debug', 'run with $DEBUG set to true') do
            $DEBUG = true
          end
          opts.on_tail('-h', '--help', 'read this help message') do
            puts opts
            exit
          end
        end
        parser.parse!(argv)

        metadata = Rumbler.build(*argv)

        if stdout
          puts metadata.to_yaml
        else
          metadata.save!  # TODO: Make sure only save when different.
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
