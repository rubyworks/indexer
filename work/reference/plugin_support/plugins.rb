if RUBY_VERSION < '1.9'
  require 'dotruby/core_ext/rubygems'
else
  require_relative 'core_ext/rubygems'
end

module DotRuby

  #
  PLUGIN_FILE = 'dotruby-*.rb'

  #
  def self.load_plugins
    find_plugins.each do |plugin|
      begin
        require plugin
      rescue LoadError => error
        warn "#{error}"
      end
    end
  end

  #
  def self.find_plugins
    matches = []

    $LOAD_PATH.each do |dir|
      files = Dir.glob(File.join(dir, PLUGIN_FILE))
      matches.concat(files)
    end

    if defined?(::Gem)
      files = ::Gem.search(PLUGIN_FILE)
      matches.concat(files)
    end

    if defined?(::Roll)
      files = ::Library.find_files(PLUGIN_FILE)
      matches.concat(files)
    end

    return matches.flatten.uniq
  end

end
