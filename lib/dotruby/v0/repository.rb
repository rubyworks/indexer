module DotRuby

  # The Repository class models a packages SCM repository
  # location.
  #
  class Repository

    # Parse `data` into a Repository instance.
    #
    def self.parse(data)
      case data
      when String
        new(data)
      when Hash
        new(data['url'], data['type'])
      else
        raise(InvalidMetadata, "repository")
      end
    end

    #
    # Initialize new Repository instance.
    #
    def initialize(url, type=nil)
      self.url  = url
      self.type = type
    end

    #
    #
    #
    attr_reader :type

    #
    # Set the type of repository. The type is a single downcased word.
    # Generally recognized types are:
    #
    # * git
    # * hg
    # * svn
    # * cvs
    # * darcs
    #
    # But any type can be used.
    #
    def type=(type)
      @type = type.to_s.downcase
    end

    #
    # The repository's public URL.
    #
    attr_reader :url

    #
    # Set repository URL>
    #
    def url=(url)
      # TODO: validate URL
      @url = url.to_s
    end

  end

end