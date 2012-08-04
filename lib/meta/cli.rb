require 'optparse'  # load OptionParser library

require_relative 'cli/about'
require_relative 'cli/source'
require_relative 'cli/gemspec'
require_relative 'cli/gemfile'

module Metadata

  # CLI is a self extend module.
  #
  module CLI
    extend self

    #
    # Command line interface.
    #
    # To write a subcommand for `rubymeta` simply create an executable script
    # with the name `rubymeta-{name}`.
    #
    def main(*argv)
      first = argv.first
      if first && !first.start_with?('-')
        system "rubymeta-#{argv.shift} " + argv.join(' ') 
      else
        if Metadata.exists?
          spec = Metadata.find
          puts spec.about
          #puts "%s %s - %s" % [spec.title, spec.version, spec.summary]
          #puts
          #spec.resources.each do |name, uri|
          #  puts "%s: %s" % [name.capitalize, uri]
          #end
          #puts
          #puts spec.copyright
        else
          $stderr.puts "No .meta file."
        end
      end
    end

  end

end

