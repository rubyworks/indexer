module DotRuby

  if RUBY_VERSION > '1.9'
    require_relative '../rubygems'
  else
    require 'dotruby/rubygems'
  end

  module RubyGems
    # Command-line interface for `dotruby-rubygems`.
    #
    # TODO: integrate better with RubyGems module code.
    def self.cli(*argv)
      require 'optparse'
      require 'fileutils'

      force  = false
      static = false
      which  = 0

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
        opt.on('--rendition', '-r INT', "select from available renditions" do |i|
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

      name = argv.shift

      copy_gemspec(:name=>name, :which=>which, :force=>force, :static=>static)
    end

    #
    def self.copy_gemspec(opts={})
      name   = opts[:name]
      force  = opts[:force]
      static = opts[:static]
      which  = opts[:which] || 0

      if name
        gemspec = "#{name}.gemspec"
      else                   # TODO: Should we find existing gemspec? 
        gemspec = '.gemspec' #Dir['{,*}.gemspec'].first || '.gemspec'
      end

      file = available_gemspecs[which]

      if File.exist?(gemspec) && !force
        $stderr.puts "gemspec already exists, use -f/--force to overwrite"
      else
        FileUtils.cp(file, gemspec)
        if static
          spec = eval(File.read(gemspec), clean_binding, gemspec)
          File.open(gemspec, 'w') do |f|
            f << spec.to_yaml
          end
        end
      end
    end

    #
    def self.clean_binding
      binding
    end
  end

end
