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
  sh "qed -Ilib qed/"
end

