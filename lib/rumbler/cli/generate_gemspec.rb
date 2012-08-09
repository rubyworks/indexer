module Rumbler

  module CLI

    #
    # Command-line interface for `rumble gemspec`.
    #
    def gemspec(*argv)
      require 'optparse'
      require 'fileutils'

      force  = false
      static = false
      which  = nil

      OptionParser.new do |opt|
        opt.banner = "Usage: #{$0} [name]"
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
        opt.on_tail('--debug', '-D', "display debugging information") do
          $DEBUG = true
        end
        opt.on_tail('--help', '-h', "display this help message") do
          puts opt
          exit 0
        end
      end.parse!(argv)

      file = argv.shift

      copy_gemspec(:file=>file, :which=>which, :force=>force, :static=>static)
    end

    #
    # Create a gemspec file. This is done by copy `vN/gemspec.rb`
    # to current directory and appending `Meta::VN::Gemspec.instance`.
    #
    def copy_gemspec(opts={})
      file   = opts[:file]
      force  = opts[:force]
      static = opts[:static]
      which  = opts[:which] || CURRENT_REVISION

      if file
        if file.extname(file) != '.gemspec'
          warn "gemspec file without .gemspec extension"
        end
      else
        # TODO: look for pre-existent gemspec, but to do that right we should get
        #       name from .meta file if it eixts.
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
        f << "\nRumbler::V#{which}::Gemspec.instance"
      end

      if static
        spec = eval(File.read(file), CleanBinding.new, file)
        File.open(file, 'w') do |f|
          f << spec.to_yaml
        end
      end
    end

    module CleanBinding
      #
      def self.new
        binding
      end
    end

  end

end
