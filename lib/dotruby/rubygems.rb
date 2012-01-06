module DotRuby

  # Functions for extending DotRuby for working with RubyGems.
  #
  # @todo this code is a mess, please help it
  module RubyGems

    #
    DIR = File.dirname(__FILE__)

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
    # TODO: techincally this is not the correct way to find this file. we can
    #       either use rbconfig.rb or move it to lib along with this code
    #
    def self.available_gemspecs
      glob  = DIR + '/../data/dotruby/*.gemspec'
      glob  = File.expand_path(glob)
      files = Dir.glob(glob)
      files.sort
    end

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

      if spec.resources
        homepage = spec.resources.homepage
      else
        homepage = nil
      end

      if homepage && md = /(\w+).rubyforge.org/.match(homepage)
        rubyforge_project = md[1]
      else
        # b/c it has to be something according to Eric Hodel.
        rubyforge_project = spec.name.to_s
      end

      ::Gem::Specification.new do |gemspec|
        gemspec.name          = spec.name.to_s
        gemspec.version       = spec.version.to_s
        gemspec.require_paths = spec.load_path.to_a

        gemspec.summary       = spec.summary.to_s
        gemspec.description   = spec.description.to_s
        gemspec.authors       = spec.authors.to_a
        gemspec.email         = spec.email.to_s
        gemspec.licenses      = spec.licenses.to_a

        gemspec.homepage      = spec.homepage.to_s

        # -- platform --

        # TODO: how to handle multiple platforms?
        #gemspec.platform = options[:platform] #|| verfile.platform  #'ruby' ???
        #if spec.platform != 'ruby'
        #  gemspec.require_paths.concat(gemspec.require_paths.collect{ |d| File.join(d, platform) })
        #end

        # -- rubyforge project --
        gemspec.rubyforge_project = rubyforge_project

        # -- dependencies --
        spec.requirements.each do |dep|
          if dep.development?
            gemspec.add_development_dependency( *[dep.name, dep.constraint].compact )
          else
            next if dep.optional?
            gemspec.add_runtime_dependency( *[dep.name, dep.constraint].compact )
          end
        end

        gemspec.requirements = spec.dependencies.map do |dep|
          [dep.name, dep.constraint].compact.join(' ') 
        end

        # -- install message --
        if spec.install_message
          gemspec.post_install_message = spec.install_message
        end

        # -- compiled extensions --
        if root
          exts = local_files(root, 'ext/**/extconfig.rb')
          gemspec.extensions = exts unless exts.empty?
        end

        # -- executables --
        # TODO: bin/ is a convention, is there are reason to do otherwise?
        if root
          bindir = local_files(root, 'bin').first
          execs  = local_files(root, 'bin/*')

          gemspec.bindir      = bindir if bindir
          gemspec.executables = execs
        end

        # -- distributed files --
        if root
          if manifest_file = Dir.glob(File.join(root, 'manifest{,.txt}')).first
            manifest = File.read(manifest_file).split("\n")
            filelist = manifest.select{ |f| File.file?(f) }
            gemspec.files = filelist
          else
            gemspec.files = root.glob_relative("**/*").map{ |f| f.to_s }
          end
        end

        # -- rdocs (argh!) --
        if root
          readme = local_files(root, 'README{,.*}', :casefold).first

          rdoc_extra = local_files(root, '[A-Z]*.*')
          rdoc_extra.unshift readme if readme
          rdoc_extra.uniq!

          gemspec.extra_rdoc_files = rdoc_extra

          rdoc_options = [] #['--inline-source']
          rdoc_options.concat ["--title", "#{spec.title}"] #if spec.title
          rdoc_options.concat ["--main", readme] if readme

          gemspec.rdoc_options = rdoc_options
        end

        # DEPRECATED: -- test files --
        #gemspec.test_files = manifest.select do |f|
        #  File.basename(f) =~ /test\// && File.extname(f) == '.rb'
        #end
      end

    private

      def local_files(root, glob, *flags)
        bits = flags.map{ |f| File.const_get("FNM_#{f.to_s.upcase}") }
        files = Dir.glob(File.join(root,glob), bits)
        files = files.map{ |f| f.sub(root,'') }
        files
      end

    end

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
