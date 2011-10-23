require 'dotruby'

module DotRuby

  # TODO: Do not use global variable, $USE_STDOUT.

  #
  def self.cli_source(*argv)
    begin
      parser = OptionParser.new do |opts|
        opts.banner = 'Usage: dotruby [options]'
        opts.on('-o', '--stdout', 'output to stdout instead of file') do
          $USE_STDOUT = true
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
      autobuild(*argv)
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
