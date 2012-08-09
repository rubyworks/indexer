module Rumbler; module V0

  module Conversion

    #
    # Create a Gem::Specification from a Meta::Spec.
    #
    # Becuase the specificaiton is extensive, a Gem::Specification
    # can be created that is sufficient for most needs. However, there
    # are a few points where the two do not intersect. In these cases
    # the remaining gemspec fields need to be provided post conversion.
    #
    # Gem::Specification fields that the specification can't provided include:
    #
    # * platform
    #
    # In addition, some information can only be provided if a project's `root`
    # directory is given. In these cases the most common project conventions
    # are utilized in determining field values. Gem::Specification fields that
    # draw from project files include:
    #
    # * files
    # * bindir
    # * extensions
    # * rdoc_options
    # * rdoc_extra_files
    #
    # Any or all of which can be reassigned post conversion, if need be.
    #
    # @param [Hash] options
    #   Convertion options.
    #
    # @option options [NilClass,String] :root
    #   project root directory
    #
    def to_gemspec(options={})
      options[:data] = self.to_h
      GemspecExporter.new(options).to_gemspec
    end

    #
    # Import a Gem::Specification into Spec. This is intended to make it
    # fairly easy to build a `.meta` file from a pre-existing `.gemspec`.
    #
    # By making this an instance method, it is possible to import other
    # resources into the Spec prior to a `.gemspec`.
    #
    # @todo Ensure all data possible is gathered from the gemspec.
    #
    def import_gemspec(gemspec)
      require 'rubygems'

      # TODO: ensure this is robust
      authors = [gemspec.authors].flatten.zip([gemspec.email].flatten)

      # TODO: how to handle license(s) ?

      if not Gem::Specification === gemspec
        # TODO: YAML-based gem specs
        gemspec = Gem::Specification.load(gemspec)
      end

      self.name         = gemspec.name
      self.version      = gemspec.version.to_s
      self.date         = gemspec.date
      self.title        = gemspec.name.capitalize
      self.summary      = gemspec.summary
      self.description  = gemspec.description || gemspec.summary
      self.authors      = authors
      self.load_path    = gemspec.require_paths
      self.homepage     = gemspec.homepage

      #self.engines      = gemspec.platform
      #self.extensions   = gemspec.extensions

      # TODO: Spec currently doesn't support multiple constraints for requirements.
      #       Probably 99.999% of the time it doesn't matter.
      gemspec.dependencies.each do |d|
        if d.type == :runtime
          add_requirement(d.name, :versions=>d.requirements_list.first)
        else
          add_requirement(d.name, :versions=>d.requirements_list.first, :development=>true)
        end
      end
    end

  end

end; end


=begin

      case gemspec
      when ::Gem::Specification
        spec = gemspec
      else
        file = Dir[root + "{*,}.gemspec"].first
        return unless file

        text = File.read(file)
        if text =~ /\A---/
          spec = ::Gem::Specification.from_yaml(text)
        else
          spec = ::Gem::Specification.load(file)
        end
      end

=end
