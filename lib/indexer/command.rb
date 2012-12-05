module Indexer

  # Command line interface.
  #
  class Command

    #
    # Shortcut to `new(argv).run`.
    #
    def self.run(argv=ARGV)
      new(argv).run
    end

    #
    #
    #
    def initialize(argv=ARGV)
      @argv     = argv

      @stdout   = false
      @force    = false
      @static   = false
      @revision = REVISION
    end

    #
    #
    #
    def run
      cmd = :show
      args = ARGV.clap @argv,
        '-d --debug'    => lambda { $DEBUG = true },
        '-w --warn'     => lambda { $VERBOSE = true },
        '-o --stdout'   => lambda{ @stdout = true },
        '-f --force'    => lambda{ @force = true },
        '-S --static'   => lambda{ @static = true },
        '-R --revision' => lambda{ |r| @revision = r.to_i },
        '-u --update'   => lambda{ cmd = :update },
        '-s --source'   => lambda{ cmd = :source },
        '-a --append'   => lambda{ cmd = :append },
        '-g --generate' => lambda{ cmd = :generate },
        '-h --help'     => lambda{ cmd = :help }
      send(cmd, *args)
    rescue => error
      raise error if $DEBUG
      $stderr.puts "#{File.basename($0)} error: #{error}"
    end

    #
    def show(*args)
      #Metadata.ensure_locked
      if Metadata.exists?
        metadata = Metadata.open
        puts metadata.about(*args)
      else
        raise Error.exception(".index file not found", IOError)
      end
    end

    # TODO: if not sources given, fallback to update?
    def source(*args)
      raise Error.exception("no sources given") if args.empty?
      metadata = Indexer.import(*args)
      if @stdout
        puts metadata.to_yaml
      else
        metadata.save!  # TODO: Make sure only save when different.
      end
    end

    #
    def update
      Metadata.ensure_locked
      metadata = Metadata.open
      if @stdout
        puts metadata.to_yaml
      else
        metadata.save!  # TODO: Make sure only save when different.
      end
    end

    #
    def append(*args)
      raise Error.exception("no sources given") if args.empty?
      metadata = Metadata.open
      metadata = Indexer.import(*(metadata.sources & args))
      if @stdout
        puts metadata.to_yaml
      else
        metadata.save!  # TODO: Make sure only save when different.
      end
    end

    #
    def generate(type, *args)
      case type
      when 'gemspec'
        create_gemspec(*args)
      else
        raise ArgumentError, "unknown file type"
      end
    end

    #
    def help
      puts <<-END
        index [command-option] [options...] [arguments...]

        -s --source [sources...]        create a .index file from sources
        -u --update                     update current .index file
        -a --append [sources...]        append source to current .index file
        -g --generate [file-type]       generate file using .index
        -h --help                       show this help message

        -o --stdout                     output to console instead of saving to file
        -f --force                      force file overwrite if file already exists
        -S --static                     generate static format (if file type supports it)
        -R --revision                   use specific revision of specification (NOT YET SUPPORTED)
      END
    end

    #
    def init(*args)
      require 'erb'

      if args.first
        outfile = args.first
      else
        outfile = "Indexfile"
      end

      if File.exist?(outfile)
        raise Error.exception("#{$0}: #{outfile} file already exists.", IOError) 
      end

      template_dir = File.join(DATADIR, "v#{REVISION}")

      if @static #yaml
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

  private

    #
    # TODO: support --stdout option
    #
    def create_gemspec(file=nil)
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

      code = GemspecExporter.source_code

      File.open(file, 'w') do |f|
        f << code
        f << "\nIndexer::GemspecExporter.gemspec"
      end

      if static
        spec = eval(File.read(file), CleanBinding.new, file)
        File.open(file, 'w') do |f|
          f << spec.to_yaml
        end
      end
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
      public :binding
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
