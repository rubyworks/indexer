if RUBY_VERSION < '1.9'
  require 'dotruby/v0/conversion/gemspec'
  require 'dotruby/v0/conversion/gemfile'
else
  require_relative 'conversion/gemspec'
  require_relative 'conversion/gemfile'
end

module DotRuby

  # Conversion module provides reoutines for converting
  # other metadata sources to and from .ruby spec.
  #
  module Conversion
  end

end

