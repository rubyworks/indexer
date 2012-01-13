require 'dotruby'

module DotRuby

  if RUBY_VERSION > '1.9'
    require_relative '../rubygems'
  else
    require 'dotruby/rubygems'
  end

  module RubyGems

    # Command-line interface for `dotruby-rubygems`.
    #
    def self.cli(*argv)
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

  end

end
