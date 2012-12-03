module Indexer

  # The Validator class models the strict *canonical* specification of
  # the index file format. It is a one-to-one mapping with no method
  # aliases or other conveniences. The class is used internally to load
  # and save index files.
  #
  class Validator < Base

    # Revision factory returns a versioned instance of the strict validating
    # specification.
    #
    # @param [Hash] data
    #   The metadata to populate the instance.
    #
    def initialize(data={})
      revision = data['revision'] || data[:revision]

      unless revision
        revison          = REVISION
        data['revision'] = REVISION
      end

      extend V[revision]::Canonical

      super(data)
    end

    # By saving via the Validator, we help ensure only the canoncial
    # form even makes it to disk.
    #
    def save!(file)
      File.open(file, 'w') do |f|
        f << to_h.to_yaml
      end
    end

  end

end
