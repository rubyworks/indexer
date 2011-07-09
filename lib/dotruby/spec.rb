# Spec class subclasses Base class.
require 'dotruby/base'

module DotRuby

  # The Specification generalized for the convenience of developers.
  # It offers method aliases and models various parts of the specification 
  # with useful classes.
  #
  # TODO: Rename to `Specification`? And "alias" as `Spec`? Or is
  # `Metadata` a better name for this? Most users will just use
  # `DotRuby.load()` anyway.
  class Spec < Base

    # Extend the Spec class with {Conventional}. This module is the 
    # the essence of Spec, giving it all it's convenient characteristics.
    #
    def initialize_model
      extend DotRuby::V[@revision]::Conventional
    end

    # Save `.ruby` file.
    #
    # @param [String] file
    #   The file name in which to save the metadata as YAML.
    #
    def save!(file='.ruby')
      to_data.save!(file)
    end

    # Read `.ruby` from file.
    #
    # @param [String] file
    #   The file name from which to read the YAML metadata.
    #
    def self.read(file)
      new Data.read(file).to_h
    end

    # Find project root and read `.ruby` file.
    #
    # @param [String] from
    #   The directory from which to start the upward search.
    #
    def self.find(from=Dir.pwd)
      read(File.join(root(from),FILE_NAME))
    end

  end

end
