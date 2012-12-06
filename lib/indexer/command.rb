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
      @argv = argv

      @force  = false
      @stdout = false
      @static = false
    end

    #
    #
    #
    def run
      cmd = nil
      args = ARGV.clap(
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
        puts metadata.about(*fields) unless fields.empty?
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
    def generate(type, *args)
      case type.downcase
      when 'gemspec'
        create_gemspec(*args)
      when 'indexfile', 'ruby'
        create_indexfile(*args)
      when 'metadata', 'yaml'
        create_metadata(*args)
      else
        raise Error.exception("unknown file type")
      end
    end

    #
    def help
      puts <<-END
        index [command-option] [options...] [arguments...]

        (none) [fields...]              update index and provide information from index
        -u --using [sources...]         create index using given information sources
        -a --adding <sources...>        update index appending additional information sources
        -r --remove <sources...>        update index removing given information sources
        -g --generate [file-type]       generate template file using the index (gemspec, indexfile, metadata)
        -h --help                       show this help message

        -o --stdout                     output to console instead of saving to file
        -f --force                      force protected file overwrite if file already exists or is up to date
        -s --static                     keep index as is or generate static format (if file-type supports it)
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

      if File.exist?(file) && !$FORCE
        $stderr.puts "`#{file}' already exists, use -f/--force to overwrite."
        exit -1
      end

      code = GemspecExporter.source_code

      File.open(file, 'w') do |f|
        f << code
        f << "\nIndexer::GemspecExporter.gemspec"
      end

      if @static
        spec = eval(File.read(file), CleanBinding.new, file)
        File.open(file, 'w') do |f|
          f << spec.to_yaml
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
