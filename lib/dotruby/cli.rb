require 'dotruby/builder'
require 'optparse'  # load OptionParser library

module DotRuby

  # TODO: Do not use global variable, $USE_STDOUT.

  # Command line interface.
  #
  # To write a commnd for DotRuby simply create an executable script
  # with the name `dotruby-{name}`.
  #
  def self.cli(*argv)
    first = argv.first
    if first && !first.start_with?('-')
      system "dotruby-#{argv.shift} " + argv.join(' ') 
    else
      begin
        source = []
        parser = OptionParser.new do |opts|
          opts.banner = 'Usage: dotruby [options]'
          opts.on('-s', '--source FILE', 'source file') do |file|
            source << file
          end
          opts.on('-o', '--stdout', 'output to stdout instead of file') do
            $USE_STDOUT = true
          end
          opts.on_tail('--debug', 'run with $DEGUG set to true') do
            $DEBUG = true
          end
          opts.on_tail('-h', '--help', 'read this help message') do
            puts opts
            exit
          end
        end
        parser.parse!(argv)
        autobuild(*source)
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

