module DotRuby

  # Validation functions.
  module Valid
    extend self

    # Uses time library to validate date-time fields.
    require 'time'

    # Valid name regular expression.
    NAME = /^[A-Za-z][A-Za-z0-9_-]*[A-Za-z0-9]$/ 

    # Valid URL regular expression.
    URL = /^(\w+)\:\/\/\S+$/

    # FIXME: Valid email address regular expression.
    EMAIL = /^\S+\@\S+$/

    # FIXME: Regular expression to limit date-time fields to ISO 8601 (Zulu).
    UTC_DATE = /^\d\d\d\d-\d\d-\d\d(\s+\d\d:\d\d:\d\d)?$/

    #
    def name?(name)
      NAME =~ name
    end

    #
    def name!(name, field=nil)
      string!(name, field)
      raise_invalid("name", name, field) unless name?(name)
    end

    #
    def url?(url)
      URL =~ url
    end

    #
    def url!(url, field=nil)
      raise_invalid("URL", url, field) unless url?(url)
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
      email
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
      string
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
    def word!(word, field=nil)
      string!(word, field)
      raise_invalid_message("#{field} must start with a letter -- #{word}") if /^[A-Za-z]/ !~ word
      raise_invalid_message("#{field} must end with a letter or number -- #{word}") if /[A-Za-z0-9]$/ !~ word
      raise_invalid_message("#{field} must be a word -- #{word}") if /[^A-Za-z0-9_-]/ =~ word
    end

    #
    #def integer_string?(integer)
    #  /^\d+$/ =~ integer
    #end

    #
    def utc_date?(date)
      return false unless string?(date)
      return false unless UTC_DATE =~ date
      begin
        Time.parse(date)
      rescue
        return false
      end
      true
    end

    #
    def utc_date!(date, field=nil)
      unless utc_date?(date)
        raise_invalid("UTC formatted date", date, field)
      end
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
    end

    # FIXME: better validation fpr path
    def path?(path)
      return false unless string?(path)
      return true
    end

    #
    def path!(path, field=nil)
      unless path?(path)
        raise_invalid("path", path, field)
      end
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

end
