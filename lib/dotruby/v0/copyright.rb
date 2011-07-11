module DotRuby

  # Copyright class models ...
  class Copyright < Model

    # Parse copyright entry.
    #
    def self.parse(copyright)
      case copyright
      when Array
        year, holder, license = *copyright
      when Hash
        year    = copyright['year']    || copyright[:year]
        holder  = copyright['holder']  || copyright[:holder]
        license = copyright['license'] || copyright[:license]
      when String
        c = copyright.dup
        c = c.sub(/(copr\.|copyright)/i,'').sub(/\(c\)/i,'').strip
        if /^(.*?\d\d\d\d)/ =~ c
          year = $1
          c = c.sub(year.to_s,'').strip
        end
        if /(\(.*?\))/ =~ c
          license = $1[1..-2]
          c = c.sub($1.to_s,'').strip
        end
        holder = c
      else
        raise ValidationError, "copyright"
      end
      new(holder, year, license)
    end

    #
    def initialize(holder, year=nil, license=nil)
      self.holder  = holder
      self.year    = year    if year
      self.license = license if license
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
      @year = year
    end

    #
    def holder=(holder)
      Valid.oneline!(holder, "copyright.holder")
      @holder = holder
    end

    #
    def license=(license)
      Valid.oneline!(license, "copyright.license")
      @license = license
    end

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
