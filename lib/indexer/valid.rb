module Indexer

  # Validation functions.
  module Valid
    extend self

    # Valid name regular expression.
    TYPE = /^[A-Za-z][\/:A-Za-z0-9_-]*[A-Za-z0-9]$/

    # Valid name regular expression.
    NAME = /^[A-Za-z][A-Za-z0-9_-]*[A-Za-z0-9]$/ 

    # Valid URL regular expression.
    URL = /^(\w+)\:\/\/\S+$/

    # Valid IRC channel.
    IRC = /^\#\w+$/

    # Regular expression for matching valid email addresses.
    EMAIL = /\b[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i  #/<.*?>/

    # FIXME: Regular expression to limit date-time fields to ISO 8601 (Zulu).
    DATE = /^\d\d\d\d-\d\d-\d\d(\s+\d\d:\d\d:\d\d)?$/

    #
    def type?(type)
      TYPE =~ type
    end

    #
    def type!(type, field=nil)
      string!(type, field)
      raise_invalid("type", type, field) unless type?(name)
      return type
    end

    #
    def name?(name)
      NAME =~ name
    end

    #
    def name!(name, field=nil)
      string!(name, field)
      raise_invalid("name", name, field) unless name?(name)
      return name
    end

    #
    def url?(url)
      URL =~ url
    end

    #
    def url!(url, field=nil)
      raise_invalid("URL", url, field) unless url?(url)
      return url
    end

    #
    def irc?(irc)
      IRC =~ irc
    end

    #
    def irc!(irc, field=nil)
      raise_invalid("IRC", irc, field) unless irc?(irc)
      return irc
    end

    #
    def uri?(uri)
      url?(uri) || irc?(uri)
    end

    #
    def uri!(uri, field=nil)
      raise_invalid("URI", uri, field) unless uri?(uri)
      return uri
    end

    #
    def email?(email)
      EMAIL =~ email
    end

    #
    def email!(email, field=nil)
      unless email?(email)
        raise_invalid("email address", email, field)
      end
      return email
    end

    #
    def oneline?(string)
      string?(string) && !string.index("\n")
    end

    #
    def oneline!(string, field=nil)
      unless oneline?(string)
        raise_invalid("one line string", string, field)
      end
      return string
    end

    #
    def string?(string)
      String === string
    end

    #
    def string!(string, field=nil)
      unless string?(string)
        raise_invalid("string", string, field)
      end
      return string
    end

    # TODO: Should we bother with #to_ary?
    def array?(array)
      Array === array || array.respond_to?(:to_ary)
    end

    #
    def array!(array, field=nil)
      unless array?(array)
        raise_invalid("array", array, field)
      end
      return array
    end

    #
    def hash?(hash)
      Hash === hash
    end

    #
    def hash!(hash, field=nil)
      unless hash?(hash)
        raise_invalid("hash", hash, field)
      end
      return hash
    end

    #
    def word?(word, field=nil)
      return false unless string?(word)
      return false if /^[A-Za-z]/ !~ word
      return false if /[A-Za-z0-9]$/ !~ word
      return false if /[^A-Za-z0-9_-]/ =~ word
      return true
    end

    #
    #--
    # TODO: Do we really need to be so detailed about the error?
    # Doing so prevent us from using #word? here.
    #++
    def word!(word, field=nil)
      string!(word, field)
      raise_invalid_message("#{field} must start with a letter -- #{word}") if /^[A-Za-z]/ !~ word
      raise_invalid_message("#{field} must end with a letter or number -- #{word}") if /[A-Za-z0-9]$/ !~ word
      raise_invalid_message("#{field} must be a word -- #{word}") if /[^A-Za-z0-9_-]/ =~ word
      return word
    end

    #
    #def integer_string?(integer)
    #  /^\d+$/ =~ integer
    #end

    # TODO: This is probably the wrong name for iso8601
    def utc_date?(date)
      return false unless string?(date)
      return false unless DATE =~ date
      begin
        Time.parse(date)
      rescue
        return false
      end
      true
    end

    # TODO: This is probably the wrong name for iso8601
    def utc_date!(date, field=nil)
      unless utc_date?(date)
        raise_invalid("ISO 8601 formatted date", date, field)
      end
      return date
    end

    # Four digit year.
    def copyright_year?(year)
      year = year.to_s
      return true if /^\d\d\d\d$/ =~ year
      return true if /^\d\d\d\d\-\d\d\d\d$/ =~ year
      return true if /^\d\d\d\d(\,\d\d\d\d)+$/ =~ year
      false
    end

    # Four digit year.
    def copyright_year!(year, field=nil)
      unless copyright_year?(year)
        raise_invalid("copyright year", year, field)
      end
      return year
    end

    #
    def version_string?(string)
      return false unless string?(string)
      return false if /^\D/ =~ string
      return false if /[^.A-Za-z0-9]/ =~ string
      return true
    end

    #
    def version_string!(value, field=nil)
      string!(value, field)
      case value
      when /^\D/
        raise_invalid_message("#{field} must start with number - #{value.inspect}")
      when /[^.A-Za-z0-9]/
        raise_invalid_message("#{field} contains invalid characters - #{value.inspect}")
      end
      return value
    end

    # FIXME: better validation for path
    def path?(path)
      return false unless string?(path)
      return true
    end

    #
    def path!(path, field=nil)
      unless path?(path)
        raise_invalid("path", path, field)
      end
      return path
    end

    #
    # TODO: Only allow double colons.
    def constant?(name)
      name = name.to_s if Symbol === name
      /^[A-Z][A-Za-z0-9_:]*/ =~ name
    end

    #
    def constant!(name, field=nil)
      unless constant?(name)
        raise_invalid("constant name", name, field)
      end
      return name
    end

    # 
    def raise_invalid(type, value, field=nil)
      case field
      when Exception
        raise(field)
      else
        if field
          message = "invalid %s for `%s' - %s" % [type, field, value.inspect]
        else
          message = "invalid %s - %s" % [type, value.inspect]
        end
        raise(ValidationError, message.strip)
      end
    end

    # 
    def raise_invalid_message(message)
      raise(ValidationError, message.strip)
    end

  end

  # Use this error for all validation errors when reading a spec.
  class ValidationError < ArgumentError
    include Error
  end

end
