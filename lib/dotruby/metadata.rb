module DotRuby

  #
  class Metadata

    #
    def initialize(data={})
      revision = data['revision'] || data[:revision]

      extend DotRuby.v(revision)::Attributes
      extend DotRuby.v(revision)::Conventional
    end

  end

end
