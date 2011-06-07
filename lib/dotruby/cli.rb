module DotRuby

  # Command line interface.
  #
  # To write a commnd for DotRuby simply create an executable script
  # with the name `dotruby-{name}`.
  #
  def self.cli(*argv)
    command = argv.shift
    if command
      cmd = "dotruby-#{command} " + argv.join(' ') 
      system cmd
    else
      puts "DotRuby v#{VERSION}"
      puts COPYRIGHT
    end
  end

end
