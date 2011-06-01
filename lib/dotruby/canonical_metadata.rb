module DotRuby

  #
  class CanonicalMetadata

    #
    def initialize(data={})
      revision = data['revision'] || data[:revision]

      extend DotRuby.v(revision)::Attributes
      extend DotRuby.v(revision)::Canonical
    end

  end

end
