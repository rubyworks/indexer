module Indexer

  # Indexer's revision strategy is a "no project left behind" strategy.
  # When using the API, is a specification is loaded that is outdated,
  # it will be upconverted to the latest standard.
  #
  # If you absolutely *must* support an old revision then use an older
  # version of Indexer, or work with the metadata manually (via YAML).
  #
  module Revision
    extend self

    #
    # Revise the metadata to current standard.
    #
    def upconvert(data)
      revision = data['revision'] || data[:revision]

      revision = REVISION unless revision

      if revision != REVISION
        begin
          require "revisions/r#{revision}"
          __send__("r#{revision}", data)
        rescue 
          raise ValidationError, "unknown revision #{revision}"
        end
      else
        data
      end
    end

    #
    # Update R2013 specification to current specification.
    #
    def r2013(data)
      data
    end

  end

end

