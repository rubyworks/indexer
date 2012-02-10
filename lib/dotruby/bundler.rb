module DotRuby

  # TODO: This is very much still a work in progress,
  
  # Bundler extension for `.ruby`.
  #
  # Currently .ruby does not support Bundler's `:git` references,
  # or `:require` option.
  #
  module Bundler

    # Dynamic `Gemfile` from `.ruby`. Just add the following code
    # to your Gemfile.
    #
    #   DotRuby::Bundler.gemfile(self)
    #
    # @todo anyway to not have to pass `self`, maybe a block but for what?
    def self.gemfile(gemfile_context)
      spec = Spec.find

      spec.requirements.each do |name, req|
        gemfile_context.gem(req.name, req.version, :group=>req.groups)
      end
    end

    # Save Gemfile based on requirements in `.ruby`. If a `Gemfile` already
    # exists it will look for a special clause to insert the script.
    #
    #     # .ruby 
    #     ... 
    #     # end .ruby
    #
    # The cluase will be replaced by the generated gemfile script. This
    # allows the file to be augemented manually.
    #
    # @todo maybe organize into group blocks
    def self.save_gemfile(file='Gemfile')
      text = gemfile_script

      if File.exist?('Gemfile')
        gemfile_text = File.read('Gemfile')
        if md = /^# \.ruby.*?^# end \.ruby/m.match(gemfile_text)
          gemfile_text.sub!(md[0], text)
        else
          gemfile_text << "\n\n" << text
        end
      else
        gemfile_text = text
      end

      File.open(file, 'w') do |f|
        f << gemfile_text
      end
    end

    # Put together a Gemfile script based in requirements given in a
    # a project's `.ruby` file.
    #
    # @return [String] Gemfile script
    def self.gemfile_script
      spec = Spec.find

      script = ['# .ruby']
      spec.requirements.each do |name, req|
        script << "gem %s, %s, :group=>%s" % [req.name.inspect, req.version.to_s,inspect, req.groups.inspect]
      end 
      script << '# end .ruby'

      script.join("\n")
    end

    #
    def self.cli(*argv)
      force  = false
      static = false

      require 'optparse'
      require 'fileutils'

      # TODO: techincally this is not the correct way to find this file. we can
      #       either use rbconfig.rb or move it to lib along with this code
      file = File.expand_path(File.dirname(__FILE__) + '/../data/dotruby/example.gemfile')

      OptionParser.new do |opt|
        opt.banner = "Usage: #{$0} [name]"
        opt.separator ""
        opt.separator "Create a Gemfile."
        opt.separator ""
        opt.on('--force', '-f', "overwrite Gemfile if present") do
          force = true
        end
        opt.on('--static', '-s', "provide a static Gemfile") do
          static = true
        end
        opt.on_tail('--debug', '-D', "display debugging information") do
          $DEBUG = true
        end
        opt.on_tail('--help', '-h', "display this help message") do
          puts opt
          exit 0
        end
      end.parse!(ARGV)

      name = ARGV.shift

      if name
        destination = name
      else
        destination = 'Gemfile'
      end

      if File.exist?(destination) && !force
        $stderr.puts "Gemfile already exists, use -f/--force to overwrite."
      else
        begin
          if static
            save_gemfile
          else
            FileUtils.cp(file, destination)
          end
        rescue Exception => error
          puts error
          raise error if $DEBUG
        end
      end

    end

  end

end
