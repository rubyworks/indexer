module Indexer

  # Conversion module provides routines for converting
  # other metadata sources to and from index format.
  #
  module Conversion
  end

end

require_relative 'conversion/gemspec'
require_relative 'conversion/gemspec_exporter'
require_relative 'conversion/gemfile'

