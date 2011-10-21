#!/usr/bin/env ruby

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yard do
    abort "Could not require 'yard'"
  end
end

desc "run tests (needs qed)"
task :test do
  sh "qed -Ilib spec/"
end

desc "coverage report"
task :cov do
  sh "qed --simplecov -Ilib qed/"
end

desc "build gem"
task :gem do
  sh "gem build dotruby.gemspec"
end

desc "release gem"
task :release => [:gem] do
  gems = Dir['*.gem'].sort
  sh "gem push #{gems.last}"
end

