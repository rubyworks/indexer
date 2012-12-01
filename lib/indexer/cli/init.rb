module Indexer

  module CLI

    #
    # Init command.
    #
    def run_init(*argv)
      yaml = false

      require 'erb'

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

      if File.exists?('Metadata')
        raise Error.exception("Metadata file already exists.", IOError) 
      end

      template_dir = File.join(DATADIR, "v#{REVISION}")

      if yaml
        template_file = File.join(template_dir, 'yaml.txt')
      else
        template_file = File.join(template_dir, 'ruby.txt')
      end

      metadata = Metadata.new

      if gemspec = find_gemspec
        metadata.import_gemspec(gemspec)
      end

      template = ERB.new(File.read(template_file))
      result   = template.result(Form.new(metadata).binding)

      File.open('Metadata', 'w') do |f|
        f << result
      end
    end

    #
    def find_gemspec
      Dir['{,pkg/}*.gemspec'].first
    end

    #
    class Form
      def initialize(metadata)
        @metadata = metadata
      end
      def method_missing(s, *a, &b)
        @metadata.public_send(s, *a, &b) || '<fill-out #{s}>'
      end
      public :binding
    end

  end

end

