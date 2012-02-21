require 'optparse'  # load OptionParser library

if RUBY_VERSION < '1.9'
  require 'dotruby/cli/about'
  require 'dotruby/cli/source'
  require 'dotruby/cli/gemspec'
  require 'dotruby/cli/gemfile'
else
  require_relative 'cli/about'
  require_relative 'cli/source'
  require_relative 'cli/gemspec'
  require_relative 'cli/gemfile'
end

module DotRuby

  module CLI

    # CLI is a self extend module.
    extend self

    # Command line interface.
    #
    # To write a commnd for DotRuby simply create an executable script
    # with the name `dotruby-{name}`.
    #
    def main(*argv)
      first = argv.first
      if first && !first.start_with?('-')
        system "dotruby-#{argv.shift} " + argv.join(' ') 
      else
        if Spec.exists?
          spec = Spec.find
          puts spec.about
          #puts "%s %s - %s" % [spec.title, spec.version, spec.summary]
          #puts
          #spec.resources.each do |name, uri|
          #  puts "%s: %s" % [name.capitalize, uri]
          #end
          #puts
          #puts spec.copyright
        else
          $stderr.puts "No .ruby file."
        end
      end
    end

  end

end

