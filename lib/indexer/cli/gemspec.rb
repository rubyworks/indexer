require 'indexer/cli'
require 'fileutils'

module Indexer

  #
  #
  #
  class CLI::Gemspec < CLI

    #
    attr_accessor :force

    #
    attr_accessor :static

    #
    attr_accessor :which

    #
    def initialize
      @force  = false
      @static = false
      @which  = REVISION
    end

    #
    def parse(opt)
      opt.banner = "Usage: #{$0} [options] [name]"
      opt.separator ""
      opt.separator "Create a gemspec file. If name is given then the file\n" +
                    "will be called `name.gemspec', otherwise just `.gemspec'."
      opt.separator ""
      opt.on('--force', '-f', "overwrite gemspec if present") do
        force = true
      end
      opt.on('--static', '-s', "provide a static gemspec") do
        static = true
      end
      opt.on('--revision', '-r INT', "specification revison") do |i|
        which = i.to_i
      end
    end

    #
    def run
      file = argv.shift

      if file
        if file.extname(file) != '.gemspec'
          warn "gemspec file without .gemspec extension"
        end
      else
        # TODO: look for pre-existent gemspec, but to do that right we should get
        #       the name from the .index file if it eixts.
        file = '.gemspec'  # Dir['{,*}.gemspec'].first || '.gemspec'
      end

      #lib_file = File.join(DIR, "v#{which}", "gemspec.rb")

      if File.exist?(file) && !force
        $stderr.puts "`#{file}' already exists, use -f/--force to overwrite."
        exit -1
      end

      code = V[which]::GemspecExporter.source_code

      File.open(file, 'w') do |f|
        f << code
        f << "\nIndexer::V#{which}::Gemspec.instance"
      end

      if static
        spec = eval(File.read(file), CleanBinding.new, file)
        File.open(file, 'w') do |f|
          f << spec.to_yaml
        end
      end
    end

    #
    #
    #
    module CleanBinding
      def self.new
        binding
      end
    end

  end

end
