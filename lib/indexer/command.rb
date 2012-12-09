module Indexer

  # Command line interface.
  #
  class Command

    #
    # Shortcut to `new.run(argv)`.
    #
    def self.run(argv=ARGV)
      new.run(argv)
    end

    #
    #
    #
    def initialize
      @force  = false
      @stdout = false
      @static = false
    end

    #
    #
    #
    def run(argv=ARGV)
      cmd = nil
      args = cli(argv,
        '-d --debug'    => lambda{ $DEBUG = true },
        '-w --warn'     => lambda{ $VERBOSE = true },
        '-f --force'    => lambda{ @force = true },
        '-o --stdout'   => lambda{ @stdout = true },
        '-s --static'   => lambda{ @static = true },
        '-u --using'    => lambda{ no_cmd!(cmd); cmd = :using },
        '-a --adding'   => lambda{ no_cmd!(cmd); cmd = :adding },
        '-g --generate' => lambda{ no_cmd!(cmd); cmd = :generate },
        '-h --help'     => lambda{ no_cmd!(cmd); cmd = :help }
      )
      send(cmd || :show, *args)
    rescue => error
      raise error if $DEBUG
      $stderr.puts "#{File.basename($0)} error: #{error}"
      exit -1
    end

    #
    # Show returns information from the `.index` file. Before doing so
    # it always ensures the `.index` file is up to date. To suppress
    # this update use the `-S/--static` option.
    #
    def show(*fields)
      if @static
        if Metadata.exists?
          metadata = Metadata.open
          puts metadata.about(*fields)
        else
          raise Error.exception(".index file not found", IOError)
        end
      else
        Metadata.lock!(:force=>@force)
        unless fields.empty?
          metadata = Metadata.open
          puts metadata.about(*fields)
        end
      end
    end

    #
    def using(*sources)
      raise Error.exception("no sources given") if sources.empty?
      metadata = Metadata.lock(sources, :force=>true)
      if @stdout
        puts metadata.to_yaml
      else
        metadata.save!
      end
    end

    #
    def adding(*sources)
      raise Error.exception("no sources given") if sources.empty?
      metadata = Metadata.open
      metadata = Metadata.lock((metadata.sources & sources), :force=>true)
      if @stdout
        puts metadata.to_yaml
      else
        metadata.save!
      end
    end

    #
    def generate(type, outfile=nil)
      case type.downcase
      when 'gemspec'
        create_gemspec(outfile)
      when 'ruby', 'index.rb', 'indexfile'
        create_ruby(outfile)
      when 'yaml', 'index.yml', 'index.yaml'
        create_yaml(outfile)
      else
        raise Error.exception("unknown file type")
      end
    end

    #
    def help
      puts <<-END
        index [command-option] [options...] [arguments...]

        (none) [fields...]              update index and provide information from index
        -u --using <sources...>         create index using given information sources
        -a --adding <sources...>        update index appending additional information sources
        -r --remove <sources...>        update index removing given information sources
        -g --generate <type> [fname]    generate a file (gemspec, indexfile, metadata)
        -h --help                       show this help message

        -o --stdout                     output to console instead of saving to file
        -f --force                      force protected file overwrite if file already exists or is up to date
        -s --static                     keep index as is or generate static format if generator supports it
      END
    end

  private

    #
    def create_ruby(outfile=nil)
      require 'erb'

      outfile = "Indexfile" unless outfile

      if File.exist?(outfile) && !(@stdout or @force)
        raise Error.exception("#{outfile} file already exists", IOError) 
      end

      template_dir  = File.join(DATADIR, "r#{REVISION}")
      template_file = File.join(template_dir, 'ruby.txt')

      if Metadata.exists?
        metadata = Metadata.open
      else
        metadata = Metadata.new
      end

      # this is a little weak, but...
      if gemspec = Dir['{,pkg/}*.gemspec'].first
        metadata.import_gemspec(gemspec)
      end

      template = ERB.new(File.read(template_file))
      result   = template.result(Form.new(metadata).get_binding)

      if @stdout
        puts result
      else
        File.open(outfile, 'w') do |f|
          f << result
        end
      end
    end

    #
    def create_yaml(outfile)
      require 'erb'

      outfile = "Index.yml" unless outfile

      if File.exist?(outfile) && !(@stdout or @force)
        raise Error.exception("#{outfile} file already exists", IOError) 
      end

      template_dir  = File.join(DATADIR, "r#{REVISION}")
      template_file = File.join(template_dir, 'yaml.txt')

      if Metadata.exists?
        metadata = Metadata.open
      else
        metadata = Metadata.new
      end

      # this is a little weak, but...
      if gemspec = Dir['{,pkg/}*.gemspec'].first
        metadata.import_gemspec(gemspec)
      end

      template = ERB.new(File.read(template_file))
      result   = template.result(Form.new(metadata).get_binding)

      if @stdout
        puts result
      else
        File.open(outfile, 'w') do |f|
          f << result
        end
      end
    end

    #
    # Create a .gemspec file for use with indexer. Or a static one if `--static` option is used.
    #
    def create_gemspec(file=nil)
      if file
        if File.extname(file) != '.gemspec'
          warn "gemspec file without .gemspec extension"
        end
      else
        # TODO: look for pre-existent gemspec, but to do that right we should get
        #       the name from the .index file if it eixts.
        file = Dir['{,*,pkg/*}.gemspec'].first || '.gemspec'
      end

      #lib_file = File.join(DIR, "v#{which}", "gemspec.rb")

      if file && File.exist?(file) && !@force
        raise Error.exception("`#{file}' already exists, use -f/--force to overwrite.")
      end

      text = GemspecExporter.source_code + "\nIndexer::GemspecExporter.gemspec"

      if @static
        spec = eval(text, CleanBinding.new, file)
        text = spec.to_yaml
      end

      if @stdout
        puts text
      else
        File.open(file, 'w') do |f|
          f << text
        end
      end
    end

    #
    def no_cmd!(cmd)
      raise Error.exception("more than one command flag") if cmd
    end

    # Helper class for generating template.
    #
    class Form
      def initialize(metadata)
        @metadata = metadata
      end
      def method_missing(s, *a, &b)
        @metadata.public_send(s, *a, &b) || '<fill-out #{s}>'
      end
      def get_binding; binding; end
    end

    #
    #
    module CleanBinding
      def self.new
        binding
      end
    end

  end

end
