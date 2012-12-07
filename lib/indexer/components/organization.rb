module Indexer

  # Organization is used to model companies involved in project.
  #
  class Organization < Model

    # Parse `entry` and create Organization object.
    def self.parse(entry)
      case entry
      when Organization
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
    def initialize(data)
      super(data)
      #raise ArgumentError, "person must have a name" unless name
    end

    #
    def initialize_attributes
      @data = {
        :roles => []
      }
    end

    #
    attr :name

    #
    def name=(name)
      Valid.oneline!(name, :name)
      @data[:name] = name
    end

    #
    attr :email

    #
    def email=(email)
      Valid.email!(email, :email)
      @data[:email] = email
    end

    #
    attr :website

    #
    def website=(website)
      Valid.url!(website, :website)
      @data[:website] = website
    end

    # List of roles the person plays in the project.
    # This can be any string or array of strings.
    attr :roles

    #
    def roles=(roles)
      @data[:roles] = (
        r = [roles].flatten
        r.each{ |x| Valid.oneline?(x) }
        r
      )
    end

    # Signular term for #roles can be used as well.
    alias :role  :roles
    alias :role= :roles=

    # Group is a synonym for role.
    alias :group  :roles
    alias :group= :roles=

    # Team is a common synonym for role too.
    alias :team   :roles
    alias :teams= :roles=

    # Convert to simple Hash represepentation.
    def to_h
      h = {}
      h['name']    = name 
      h['email']   = email   if email
      h['website'] = website if website
      h['roles']   = roles   if not roles.empty?
      h
    end

    # CONSIDER: Only name has to be equal?
    def ==(other)
      return false unless Organization === other
      return false unless name == other.name
      return true
    end
  end

end
