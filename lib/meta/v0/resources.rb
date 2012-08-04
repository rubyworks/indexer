module Metadata; module V0

  # The Resources class models a table of project releated URIs.
  # Each entry has a name and URI. The class is Enumerable so
  # each entry can be iterated over, much like a Hash.
  #
  # The class also recognizes common entry names and aliases,
  # which can be accessed via method calls.
  #
  class Resources < Model
    include Enumerable

    # TODO: Consider if this should instead be an associative array
    # of [type, uri]. Could there not be more than one URL for
    # a given type?

    # TODO: Resource aliases are probably the trickiest part of this
    # specification. It's hard to judge what exactly they should be.

    ## Valid URL regular expression.
    #URL = /^(\w+)\:\/\/\S+$/

    @key_aliases = {}

    #
    def self.key_aliases
      @key_aliases
    end

    #
    def self.attr_accessor *aliases
      code = []
      aliases.each do |method|
        key_aliases[method.to_sym] = aliases
        code << "def #{method}"
        code << "  self['#{name}']"
        code << "end"
        code << "def #{method}=(val)"
        code << "  self['#{name}'] = val"
        code << "end"
      end
      module_eval code.join("\n") 
    end

    # New Resources object. The initializer can
    # take a hash of name to URL.
    def initialize(data={})
      @table = {}

      data = {} if data.nil?

      data.each do |key, uri|
        self[key] = uri
      end
    end

    #
    #def key_index(key)
    #  key = key.to_sym
    #  self.class.key_aliases[key] || key
    #end

    #
    def key_aliases
      self.class.key_aliases
    end

    # Get a resource URI.
    #
    def [](key)
      #@table[key_index(key)]
      @table[find_key(key)]
    end

    # Add a resource.
    #
    # This is rather inefficient, but it does the job right.
    # If there is an optimized way to go about it, hey, let us know.
    #
    def []=(key, uri)
      unless Valid.url?(uri) or Valid.irc?(uri)
        raise ValidationError, "Not a valid URI - `#{uri}' for `#{key}'"
      end
      #@table[key_index(key)] = uri
      select_keys(key).each do |k|
        @table.delete(k)
      end
      @table[key.to_sym] = uri
    end

    # Offical project website.
    attr_accessor :homepage, :home

    # Location of development site.
    attr_accessor :development, :work, :dev

    # Package distribution service webpage.
    attr_accessor :gem, :distro, :distributor

    # Location to downloadable package(s).
    attr_accessor :download

    # Browse source code.
    attr_accessor :code, :source, :source_code

    # User discussion forum.
    attr_accessor :forum

    # Location of support forum.
    attr_accessor :support

    # Mailing list email or web address to online version.
    attr_accessor :mail, :email, :mailinglist

    # Location of issue tracker.
    attr_accessor :bugs, :issues

    # Location of documentation.
    attr_accessor :docs, :documentation, :doc

    # Location of API reference documentation.
    attr_accessor :api, :reference, :system_guide

    # Location of wiki.
    attr_accessor :wiki, :user_guide

    # Resource to project blog.
    attr_accessor :blog, :weblog

    # IRC channel
    attr_accessor :irc, :chat

    # Convert to Hash by duplicating the underlying
    # hash table.
    def to_hash
      @table.dup
    end

    # Convert table to hash with string keys.
    def to_h
      h = {}
      @table.each do |k,v|
        h[k.to_s] = v
      end
      return h
    end

    #
    def empty?
      @table.empty?
    end

    # Iterate over each enty.
    def each(&block)
      @table.each(&block)
    end

    # The size of the table.
    def size
      @table.size
    end

    #
    def to_a
      @table.map{ |k,v| [k,v] }
    end

    #
    def inspect
      @table.inspect
    end

    #
    def merge!(res)
      res.each do |key, uri|
        self[key] = uri
      end
    end

    # Locate an entry with a matching key.
    def find_key(key)
      names = (key_aliases[key] || []) + [key]
      @table.keys.each do |k|
        return k if k.to_s.downcase =~ /(#{names.join('|').downcase})/
      end
      key
    end

    #
    def select_keys(key)
      names = (key_aliases[key] || []) + [key]
      @table.keys.select do |k|
        k.to_s.downcase =~ /(#{names.join('|').downcase})/
      end
    end

    # If a method is missing and it is a setter method
    # (ending in '=') then a new entry by that name
    # will be added to the table. If a plain method
    # then the name will be looked for in the table.
    def method_missing(sym, *args)
      meth = sym.to_s
      name = meth.chomp('=')
      case meth
      when /=$/
        self[name] = args.first
      else
        super(sym, *args) if block_given? or args.size > 0
        self[name]
      end
    end

  end

end; end
