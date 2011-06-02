module DotRuby

  # TODO: What shall we call this class? It is the "convenience" specification.
  class Metadata

    #
    def initialize(data={})
      revision = data['revision'] || data[:revision]

      extend DotRuby.v(revision)::Attributes
      extend DotRuby.v(revision)::Conventional
    end

  end

end
