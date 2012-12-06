module Indexer

  # Copyright class models a copyright holer, the year of copyright
  # and the accosiated license.
  #
  class Copyright < Model

    # Parse copyright entry.
    #
    def self.parse(copyright, default_license=nil)
      case copyright
      when Array
        year, holder, license = *copyright
      when Hash
        year    = copyright['year']    || copyright[:year]
        holder  = copyright['holder']  || copyright[:holder]
        license = copyright['license'] || copyright[:license]
      when String
        case copyright
        when /(\d\d\d\d)\s+(.*?)\s*\((.*?)\)$/
          year, holder, license = $1, $2, $3
        when /(\d\d\d\d)\s+(.*?)\s*$/
          year, holder, license = $1, $2, nil
        when /(opyright|\(c\))(.*?)\s*\((.*?)\)$/
          year, holder, license = nil, $1, $2
        when /(opyright|\(c\))(.*?)\s*$/
          year, holder, license = nil, $1, nil
        end
      else
        raise ValidationError, "copyright"
      end
      license = license || default_license
      new(:holder=>holder, :year=>year, :license=>license)
    end

    #
    def initialize(data)
      super(data)
      raise(ValidationError, "copyright must have a holder") unless holder
    end

    #
    attr :year

    #
    attr :holder

    #
    attr :license

    #
    def year=(year)
      Valid.copyright_year!(year, "copyright.year")
      @data[:year] = year
    end

    #
    def holder=(holder)
      Valid.oneline!(holder, "copyright.holder")
      @data[:holder] = holder
    end

    #
    def license=(license)
      if license.nil?
        @data.delete(:license)
      else
        Valid.oneline!(license, "copyright.license")
        @data[:license] = license
      end
    end

    #
    # Standard copyright stamp.
    #
    def to_s
      s = ["Copyright (c)"]
      s << year if year
      s << holder
      s << "(#{license})" if license
      s.join(' ') + ". All Rights Reserved."
    end

    #
    def to_h
      h = {}
      h['holder']  = holder
      h['year']    = year    if year
      h['license'] = license if license
      h
    end

  end

end
