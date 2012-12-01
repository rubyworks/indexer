module Indexer; module V0

  class Validator < Base
    include Canonical

    # By saving via the Validator, we help ensure only the canoncial
    # form even makes it to disk.
    #
    def save!(file)
      File.open(file, 'w') do |f|
        f << to_h.to_yaml
      end
    end
  end

end; end
