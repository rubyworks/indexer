require 'optparse'  # load OptionParser library

if RUBY_VERSION < '1.9'
  require 'metaspec/cli/about'
  require 'metaspec/cli/source'
  require 'metaspec/cli/gemspec'
  require 'metaspec/cli/gemfile'
else
  require_relative 'cli/about'
  require_relative 'cli/source'
  require_relative 'cli/gemspec'
  require_relative 'cli/gemfile'
end

module Meta

  module CLI

    # CLI is a self extend module.
    extend self

    # Command line interface.
    #
    # To write a commnd for Metaspec simply create an executable script
    # with the name `metaspec.ruby-{name}`.
    #
    def main(*argv)
      first = argv.first
      if first && !first.start_with?('-')
        system "metaspec.ruby-#{argv.shift} " + argv.join(' ') 
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
          $stderr.puts "No .meta file."
        end
      end
    end

  end

end

