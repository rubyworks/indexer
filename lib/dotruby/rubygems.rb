module DotRuby

  # Functions for extending DotRuby for working with RubyGems.
  #
  # @todo this code is a mess, please help it
  module RubyGems

    #
    DIR = File.dirname(__FILE__)

    #
    # Require RubyGems library.
    #
    def self.require_rubygems
      begin
        require 'rubygems' #/specification'
        #::Gem::manage_gems
      rescue LoadError
        raise LoadError, "RubyGems is not installed."
      end
    end

    #
    # Create a Gem::Specification from a DotRuby::Spec.
    #
    # Becuase the DotRuby specificaiton is extensive, a Gem::Specification
    # can be created that covers most of the data-points it supports. However,
    # there are a few places where the two do not intersect. In these cases
    # the remaining gemspec fields need to be provided post conversion.
    # Gem::Specification fields that DotRuby can't provided include:
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
    # Any or all of which can be reassigned post conversion, if needs be.
    #
    # @param [DotRuby::Spec] spec
    #   .ruby spec object
    #
    # @param [NilClass,String] root
    #   project root directory
    #
    def self.gemspec(spec, root=nil)
      require_rubygems
      Gemspec.new(:root=>root, :data=>spec.to_h).to_gemspec
    end

    #
    # Create a gemsepc file. This is done by copy vX/gemspec.rb
    # to current directory and appending `DotRuby::VX::Gemspec.instance`.
    #
    def self.copy_gemspec(opts={})
      file   = opts[:file]
      force  = opts[:force]
      static = opts[:static]
      which  = opts[:which] || 0

      if file
        if file.extname(file) != '.gemspec'
          warn "gemspec file without .gemspec extension"
        end
      else
        # TODO: look for pre-existent gemspec, but to do that right we should get
        #       name from .ruby file if it eixts.
        file = '.gemspec'  # Dir['{,*}.gemspec'].first || '.gemspec'
      end

      lib_file = File.join(DIR, "v#{which}", "gemspec.rb")

      if File.exist?(file) && !force
        $stderr.puts "`#{file}' already exists, use -f/--force to overwrite."
      else
        FileUtils.cp(lib_file, file)

        File.open(file, 'a') do |f|
          f << "\nDotRuby::V#{which}::Gemspec.instance"
        end

        if static
          spec = eval(File.read(file), clean_binding, lib_file)
          File.open(file, 'w') do |f|
            f << spec.to_yaml
          end
        end
      end
    end

  private

    #
    def self.clean_binding
      binding
    end

    #def local_files(root, glob, *flags)
    #  bits = flags.map{ |f| File.const_get("FNM_#{f.to_s.upcase}") }
    #  files = Dir.glob(File.join(root,glob), bits)
    #  files = files.map{ |f| f.sub(root,'') }
    #  files
    #end

    # If the source file is a gemspec, import it.
    #
    # Note: This is not the recommended way of doing things. Rather we highly
    # recommend maintaing a `.ruby` file and producing the gemspec from it.
    # But, we also support developer choice, so if you want to go the other
    # way round feel free. This can also serve as a temporary measure
    # until you make the transition to using .ruby as the primary metadata
    # file.
    module Autobuild
      def autobuild(source)
        case File.extname(source)
        when '.gemspec'
          # TODO: handle YAML-based gemspecs
          gemspec = ::Gem::Specification.load(source)
          @spec.import_gemspec(gemspec)
        else
          super(source) if defined?(super)
        end
      end
    end

    # TODO: Shouldn't this be in V0 ?
    #
    module Specable
      # Create a Gem::Specification from a  .ruby Spec. Because Spec is extensive
      # a fairly complete a Gem::Specification can be created from it which is 
      # sufficient for almost all needs.
      #
      def to_gemspec(options={})
        RubyGems.gemspec(self, options)
      end

      # TODO: Better name for this method?

      # TODO: Ensure all data possible is gathered from the gemspec.

      # Import a Gem::Specification into Spec. This is intended to make it
      # fairly easy to build a `.ruby` file from a pre-existing `.gemspec`.
      #
      # By making this an instance method, it is possible to import other
      # resources into the Spec prior to a `.gemspec`.
      def import_gemspec(gemspec)
        self.name         = gemspec.name
        self.version      = gemspec.version.to_s
        self.title        = gemspec.name.capitalize
        self.summary      = gemspec.summary
        self.description  = gemspec.description || gemspec.summary
        self.authors      = gemspec.authors
        #self.maintainers  = gemspec.email
        self.load_path    = gemspec.require_paths

        self.resources.homepage = gemspec.homepage

        #self.engines    = gemspec.platform
        #self.extensions   = gemspec.extensions

        # TODO: DotRuby currently doesn't support multiple constraints for requirements.
        #       Probably 99.999% of the time it doesn't matter.
        gemspec.dependencies.each do |d|
          if d.type == :runtime
            add_requirement(d.name, :versions=>d.requirements_list.first)
          else
            add_requirement(d.name, :versions=>d.requirements_list.first, :development=>true)
          end
        end
      end

      # Create a new Spec given a gemspec.
      #
      # @param [Gem::Specification] gemspec object
      def self.parse_gemspec(gemspec)
        new.import_gemspec(gemspec)
      end
    end

  end

  #
  class Builder
    include RubyGems::Autobuild
  end

  #
  class V0::Specification
    include RubyGems::Specable
  end

end



=begin
      begin
        require 'rubygems'
      rescue LoadError
        return 
      end

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
            name = File.basename(file)
      self.name         = spec.name
      self.version      = spec.version.to_s
      self.path         = spec.require_paths
      #self.engines     = spec.platform

      self.title        = spec.name.capitalize
      self.summary      = spec.summary
      self.description  = spec.description
      self.authors      = spec.authors
      self.contact      = spec.email

      self.resources.homepage = spec.homepage

      #metadata.extensions   = spec.extensions

      spec.runtime_dependencies.each do |d|
        requires << "#{d.name} #{d.version_requirements}"
      end

      # TODO
      #spec.development_dependencies.each do |d|
      #  requires << "#{d.name} #{d.version_requirements} (development)"
      #end

=end
