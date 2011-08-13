# TODO: ultimately we can break this down into groups based on version (vo, v1 ext)
require 'simplecov'
SimpleCov.start do
  coverage_dir 'log/coverage'
  add_group "Shared" do |src_file|
    /lib\/dotruby\/v(\d+)(.*?)$/ !~ src_file.filename
  end
  add_group "Revision 0", "lib/dotruby/v0"
end