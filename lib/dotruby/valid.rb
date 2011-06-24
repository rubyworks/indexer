module DotRuby

  # Validation functions.
  module Valid
    extend self

    # Valid name regular expression.
    NAME = /^[A-Za-z][A-Za-z0-9_]*$/ 

    # Valid URL regular expression.
    URL = /^(\w+)\:\/\/\S+$/

    # FIXME: Valid email address regular expression.
    EMAIL = /^\S+\@\S+$/

    #
    def name?(name)
      NAME =~ name
    end

    #
    def name!(name, exception=nil)
      raise(exception || "not a valid name - #{name}") unless name?(name)
      name
    end

    #
    def url?(url)
      URL =~ url
    end

    #
    def url!(url, exception=nil)
      raise(exception || "not a valid URL - #{url}") unless url?(url)
      url
    end

    #
    def email?(email)
      EMAIL =~ email
    end

    #
    def email!(email, exception=nil)
      unless email?(email)
        raise(exception || "not a valid email address - #{email}")
      end
      email
    end

    #
    def integer?(integer)
      /^\d+$/ =~ integer
    end

    private

    # 
    def raise(message)
      case message
      when Exception
        super message
      else
        super InvalidMetadata, message
      end
    end

  end

end
