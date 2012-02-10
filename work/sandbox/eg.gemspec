# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{example}
  s.version = '1.0.0'
  s.authors = ["Daniel Neighman"]
  s.date = %q{2011-07-27}
  s.email = %q{has.sox@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.textile"
  ]
  s.files = Dir["**/*"] - Dir["*.gem"]
  s.homepage = %q{http://github.com/hassox/warden}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{warden}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Rack middleware that provides authentication for rack applications}
  s.add_dependency "rack", ">= 1.0"
end

