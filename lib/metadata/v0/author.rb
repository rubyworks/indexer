module Metadata; module V0

  # Author class is used to model Authors and Maintainers.
  #
  # TODO: Should Author have an `organization` field. If so
  # is it a map with `name` and `website` fields?
  #
  # TODO: Should we have `team` field (think Github)?
  #
  class Author < Model

    # Parse `entry` and create Author object.
    def self.parse(entry)
      case entry
      when Author
        entry
      when String
        parse_string(entry)
      when Array
        parse_array(entry)
      when Hash
        new(entry)
      end
    end

    #
    def self.parse_array(array)
      data = {}
      array.each do |value|
        v = value.strip
        case v
        when /^(.*?)\s*\<(.*?@.*?)\>/
          data[:name]  = $1 unless $1.empty?
          data[:email] = $2
        when /^(http|https)\:/
          data[:website] = v
        when /\@/
          data[:email] = v
        else
          data[:name] = v
        end
      end
      new(data)
    end

    #
    def self.parse_string(string)
      if md = /(.*?)\s*\<(.*?)\>/.match(string)
        new(:name=>md[1], :email=>md[2])
      else
        new(:name=>string)
      end
    end

    #
    def initialize(settings)
      @roles = []

      settings.each do |field, value|
        send("#{field}=", value)
      end
      #raise ArgumentError, "person must have a name" unless name
    end

    #
    attr :name

    #
    def name=(name)
      Valid.oneline!(name, :name)
      @name = name
    end

    #
    attr :email

    #
    def email=(email)
      Valid.email!(email, :email)
      @email = email
    end

    #
    attr :website

    #
    def website=(website)
      Valid.url!(website, :website)
      @website = website
    end

    #
    attr :team

    # TODO: validate team
    def team=(team)
      @team = team
    end

    # List of roles the person plays in the project.
    # This can be any string or array of strings.
    attr :roles

    #
    def roles=(role)
      @roles = (
        r = [role].flatten
        r.each{ |x| Valid.oneline?(x) }
        r
      )
    end

    alias :role  :roles
    alias :role= :roles=

    #
    def to_h
      h = {}
      h['name']    = name 
      h['email']   = email   if email
      h['website'] = website if website
      h['roles']   = roles   if not roles.empty?
      h
    end

    # CONSIDE: Only name has to be equal?
    def ==(other)
      return false unless Author === other
      return false unless name == other.name
      return true
    end
  end

end; end
