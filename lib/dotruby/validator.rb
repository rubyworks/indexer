if RUBY_VERSION > '1.9'
  require_relative 'base'
else
  require 'dotruby/base'
end

module DotRuby

  # The Validator class models the strict *canonical* specification of
  # the `.ruby` file format. It is a one-to-one mapping with no method
  # aliases or other conveniences. The class is used internally to load
  # and save `.ruby` files.
  #
  class Validator < Base

    # Revision factory return a versioned instance of Specification.
    #
    # @param [Hash] data
    #   The metadata to populate the instance.
    #
    def initialize(data={})
      revision = data['revision'] || data[:revision]
      unless revision
        revison          = CURRENT_REVISION
        data['revision'] = CURRENT_REVISION
      end
      #extend V[revision]::Attributes
      extend V[revision]::Validators
      super(data)
    end

  end

end
