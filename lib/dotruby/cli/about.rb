module DotRuby

  module CLI

    #
    def about(*argv)
      verbose = false
      begin
        parser = OptionParser.new do |opts|
          opts.banner = 'Usage: dotruby about [part ...]'
          opts.on_tail('--debug', 'run with $DEBUG set to true') do
            $DEBUG = true
          end
          opts.on_tail('-h', '--help', 'read this help message') do
            puts opts
            exit
          end
        end
        parser.parse!(argv)

        if Spec.exists?
          spec = Spec.find
          puts spec.about(*argv)
        else
          raise Error.exception("no .ruby file found", IOError)
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

