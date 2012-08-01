module Meta

  module CLI

    #
    # Build .meta file from external sources.
    #
    # @todo Rename to cli_build ?
    #
    def source(*argv)
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

        spec = Meta.build(*argv)

        if stdout
          puts spec.to_yaml
        else
          spec.save!  # TODO: Make sure only save when different.
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
