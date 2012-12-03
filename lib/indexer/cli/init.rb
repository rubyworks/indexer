require 'indexer/cli'
require 'erb'

module Indexer

  #
  #
  #
  class CLI::Init < CLI

    attr_accessor :yaml

    #
    def initialize
      @yaml = false
    end

    #
    def parse(opts)
      opts.banner = "Usage: #{$0} [options]"
      opts.on_tail('--yaml', 'use a YAML-based Metafile') do
        self.yaml = true
      end
    end

    #
    def run
      if argv.first
        outfile = argv.first
      else
        outfile = "Indexfile"
      end

      if File.exist?(outfile)
        raise Error.exception("#{$0}: #{outfile} file already exists.", IOError) 
      end

      template_dir = File.join(DATADIR, "v#{REVISION}")

      if yaml
        template_file = File.join(template_dir, 'yaml.txt')
      else
        template_file = File.join(template_dir, 'ruby.txt')
      end

      metadata = Metadata.new

      if gemspec = Dir['{,pkg/}*.gemspec'].first
        metadata.import_gemspec(gemspec)
      end

      template = ERB.new(File.read(template_file))
      result   = template.result(Form.new(metadata).binding)

      File.open(outfile, 'w') do |f|
        f << result
      end
    end

    #
    # Helper class for generating template.
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
