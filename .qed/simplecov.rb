# TODO: ultimately we can break this down into groups based on version (vo, v1 ext)
require 'simplecov'
SimpleCov.start do
  coverage_dir 'site/coverage'
  add_group "Shared", "lib/dotruby"
  add_group "Revision 0", "lib/dotruby/v0"
end
