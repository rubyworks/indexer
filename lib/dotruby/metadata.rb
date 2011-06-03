module DotRuby

  # TODO: What shall we call this class? It is the "convenience" specification.
  class Metadata

    #
    def initialize(data={})
      @revision = data['revision'] ||
                  data[:revision]  ||
                  CURRENT_REVISION

      extend DotRuby.v(revision)::Attributes
      extend DotRuby.v(revision)::Conventional

      initialize_attributes

      merge!(data)
    end

  end

end
