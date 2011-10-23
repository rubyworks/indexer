require 'dotruby/builder'
require 'optparse'  # load OptionParser library

module DotRuby

  # Command line interface.
  #
  # To write a commnd for DotRuby simply create an executable script
  # with the name `dotruby-{name}`.
  #
  def self.cli(*argv)
    first = argv.first
    if first && !first.start_with?('-')
      system "dotruby-#{argv.shift} " + argv.join(' ') 
    else
      if Spec.exists?
        spec = Spec.find
        puts "%s %s - %s" % [spec.title, spec.version, spec.summary]
        puts
        spec.resources.each do |name, uri|
          puts "%s: %s" % [name.capitalize, uri]
        end
        puts
        puts spec.copyright
      else
        $stderr.puts "No .ruby file."
      end
    end
  end

end

