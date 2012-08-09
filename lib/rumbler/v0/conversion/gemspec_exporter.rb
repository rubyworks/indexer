# encoding: utf-8
module Rumbler; module V0

  #
  class GemspecExporter

    # For which revision this gemspec intended?
    REVISION = 0 unless defined?(REVISION)

    #
    PATTERNS = {
      :bin_files  => 'bin/*',
      :lib_files  => 'lib/{**/}*.rb',
      :ext_files  => 'ext/{**/}extconf.rb',
      :doc_files  => '*.{txt,rdoc,md,markdown,tt,textile}',
      :test_files => '{test/{**/}*_test.rb,spec/{**/}*_spec.rb}'
    } unless defined?(PATTERNS)

    #
    def self.instance
      new.to_gemspec
    end

    # FIXME: what if there is no project directory to be had?

    def initialize(options={})
      require 'yaml'

      @root_dir = options[:root] #|| Dir.pwd
      @metadata = options[:data] || YAML.load_file(File.join(@root_dir, '.meta'))

      if @metadata['revision'].to_i != REVISION
        warn "You have the wrong revision. Trying anyway..."
      end
    end

    #
    attr :metadata

    #
    def manifest
      @manifest ||= \
        if @root_dir
          Dir.glob('manifest{,.txt}', File::FNM_CASEFOLD).first
        end
    end

    #
    def scm
      @scm ||= \
        case
        when File.directory?('.git')
          :git
        end
    end

    #
    def files
      @files ||= \
        #glob_files[patterns[:files]]
        case
        when manifest
          File.readlines(manifest).
            map{ |line| line.strip }.
            reject{ |line| line.empty? || line[0,1] == '#' }
        when scm == :git
         `git ls-files -z`.split("\0")
        else
          Dir.glob('{**/}{.*,*}')  # TODO: be more specific using standard locations ?
        end.select{ |path| File.file?(path) }
    end

    #
    def glob_files(pattern)
      return [] unless @root_dir

      Dir.glob(pattern).select do |path|
        File.file?(path) && files.include?(path)
      end
    end

    #
    def patterns
      PATTERNS
    end

    #
    def executables
      @executables ||= \
        glob_files(patterns[:bin_files]).map do |path|
          File.basename(path)
        end
    end

    def extensions
      @extensions ||= \
        glob_files(patterns[:ext_files]).map do |path|
          File.basename(path)
        end
    end

    def name
      metadata['name'] || metadata['title'].downcase.gsub(/\W+/,'_')
    end

    def homepage
      metadata['resources'].find{ |key, url| key =~ /^home/ }
    end

    #
    def to_gemspec
      if @root_dir
        Dir.chdir(@root_dir) do
          ::Gem::Specification.new do |gemspec|
            set_gemspec_primary(gemspec)
            set_gemspec_files(gemspec)
          end
        end
      else
        ::Gem::Specification.new do |gemspec|
          set_gemspec_primary(gemspec)
        end
      end
    end

  private

    def set_gemspec_primary(gemspec)
      gemspec.name        = name
      gemspec.version     = metadata['version']
      gemspec.summary     = metadata['summary']
      gemspec.description = metadata['description']

      metadata['authors'].each do |author|
        gemspec.authors << author['name']

        if author.has_key?('email')
          if gemspec.email
            gemspec.email << author['email']
          else
            gemspec.email = [author['email']]
          end
        end
      end

      gemspec.licenses = metadata['copyrights'].map{ |c| c['license'] }.compact

      metadata['requirements'].each do |req|
        next if req['optional']

        name    = req['name']
        version = req['version']
        groups  = req['groups'] || []

        case version
        when /^(.*?)\+$/
          version = ">= #{$1}"
        when /^(.*?)\-$/
          version = "< #{$1}"
        when /^(.*?)\~$/
          version = "~> #{$1}"
        end

        if groups.empty? or groups.include?('runtime')
          # populate runtime dependencies  
          if gemspec.respond_to?(:add_runtime_dependency)
            gemspec.add_runtime_dependency(name,*version)
          else
            gemspec.add_dependency(name,*version)
          end
        else
          # populate development dependencies
          if gemspec.respond_to?(:add_development_dependency)
            gemspec.add_development_dependency(name,*version)
          else
            gemspec.add_dependency(name,*version)
          end
        end
      end

      # convert external dependencies into a requirements
      if metadata['external_dependencies']
        ##gemspec.requirements = [] unless metadata['external_dependencies'].empty?
        metadata['external_dependencies'].each do |req|
          gemspec.requirements << req.to_s
        end
      end

      # determine homepage from resources
      homepage = metadata['resources'].find{ |r| r['type'] == 'home' } ||
                 metadata['resources'].find{ |r| r['type'] == 'web' }  ||
                 metadata['resources'].find{ |r| r['label'].to_s =~ /^(home|web)/i }
      gemspec.homepage = homepage['uri'] if homepage

      gemspec.require_paths        = metadata['load_path'] || ['lib']
      gemspec.post_install_message = metadata['install_message']
    end

    #
    # RubyGems specific metadata items.
    #
    def set_gemspec_files(gemspec)

      gemspec.files       = files
      gemspec.extensions  = extensions
      gemspec.executables = executables

      if ::Gem::VERSION < '1.7.'
        gemspec.default_executable = gemspec.executables.first
      end

      gemspec.test_files = glob_files(patterns[:test_files])

      unless gemspec.files.include?('.document')
        gemspec.extra_rdoc_files = glob_files(patterns[:doc_files])
      end
    end

    #
    # Return a copy of this file. This is used to generate a local
    # .gemspec file that can automatically read the .meta file.
    #
    def self.source_code
      File.read(__FILE__)
    end

  end #class GemspecExporter

end; end



# FIXME: TEMPORARY REFERENCE - handling no root

=begin

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

  end
=end
