module DotRuby

  # Autobuild .ruby specification.
  def self.autobuild
    spec   = Spec.find
    source = spec.source

    builder = Builder.new
    specx   = Spec.new
    source.each do |src|
      builder.autobuild(specx, src)
    end
    # FIXME: only save if different, equality currently does not work
    specx.save! if spec != specx
  end

  # Builder class takes disperate data sources and imports them
  # into the .ruby specification.
  #
  class Builder

    #
    def autobuild(spec, source)
      super(spec, source) if defined?(super)
    end

    # Standard Builder module.
    #
    module Standard

      # Standard autobuild procedure.
      #
      def autobuild(spec, source)
        case File.extname(source)
        when '.yaml', '.yml'
          spec.merge!(YAML.load_file(source))
        when '.rb'
          # TODO: way to handle this?
        end
      end

    end

    include Standard

  end

end


  #case File.extname(src)
  #when '.gemspec'
  # TODO: import gemspec (this needs to be in rubygems extension)

