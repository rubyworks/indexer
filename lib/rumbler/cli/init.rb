module Rumbler

  module CLI

    #
    # Init command.
    #
    def run_init(*argv)
      yaml = false

      begin
        parser = OptionParser.new do |opts|
          opts.banner = "Usage: #{$0} init"
          opts.on_tail('--yaml', 'use a YAML-based Metafile') do
            yaml = true
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

        template_dir = File.join(DATADIR, "v#{REVISION}")

        if yaml
          template = File.join(template_dir, 'yaml.txt')
        else
          template = File.join(template_dir, 'ruby.txt')
        end

        if File.exists?('Metadata')
          raise Error.exception("Metadata file already exists.", IOError) 
        else
          File.open('Metadata', 'w') do |f|
            f << File.read(template)
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
    end

  end

end

