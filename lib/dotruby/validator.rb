# Validator class subclasses Base class.
require 'dotruby/base'

module DotRuby

  # The Validator class models the strict *canonical* specification of
  # the `.ruby` file format. It is a one-to-one mapping with no method aliases
  # or other conveniences. The class is used internally by the Spec to load
  # `.ruby` files.
  #
  class Validator < Base

    #
    def initialize_model
      extend DotRuby::V[@revision]::Canonical
    end

    # Read `.ruby` from file.
    #
    # @param [String] file
    #   The file name in which to read the YAML metadata.
    #
    def self.read(file)
      new(YAML.load_file(file))
    end

=begin
    # Find project root and read `.ruby` file.
    #
    # @param [String] from
    #   The directory from which to start the upward search.
    #
    def self.find(from=Dir.pwd)
      read(File.join(root(from),FILE_NAME))
    end

    # Convert to Spec.
    #
    #
    def to_spec
      Spec.new(to_h)
    end
=end

  end

end
