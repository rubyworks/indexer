if RUBY_VERSION < '1.9'
  require 'metaspec/v0/conversion/gemspec'
  require 'metaspec/v0/conversion/gemfile'
else
  require_relative 'conversion/gemspec'
  require_relative 'conversion/gemfile'
end

module Meta

  module V0 # ?

    # Conversion module provides routines for converting
    # other metadata sources to and from metaspec.
    #
    module Conversion
    end

  end

end

