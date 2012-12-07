# TEMPORARY REFERENCE - handling no root

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

