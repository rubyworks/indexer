module Indexer

  # The Repository class models a packages SCM repository location.
  # It consists of two parts, the `scm` type of repository, it's `url`.
  #
  class Repository < Model

    # Parse `data` returning a new Repository instance.
    #
    # @param data [String,Array<String>,Array<Hash>,Hash]
    #   Repository information.
    #
    # @return [Repository] repository instance
    #--
    # TODO: Should String be allowed, and thus no `id`?
    #++
    def self.parse(data)
      case data
      when String
        new('uri'=>data)
      when Array
        h, d = {}, data.dup  # TODO: data.rekey(&:to_s)
        h.update(d.pop) while Hash === d.last
        h['name'] = d.shift.to_s unless d.empty?
        h['uri']  = d.shift.to_s unless d.empty?
        h['scm']  = d.shift.to_s unless d.empty?
        new(h)
      when Hash
        new(data)
      else
        raise(ValidationError, "not a valid repository")
      end
    end

    #
    # Initialize new Repository instance.
    #
    def initialize(data={})
      super(data)

      self.scm = infer_scm(uri) unless scm
    end

    #
    # A name that can be used to identify the purpose of a
    # particular repository.
    #
    attr_reader :name

    #
    # Set the repository name. This can be any one line description but
    # it generally should be a brief one-word indictor such as "origin"
    # "upstream", "experimental", "joes-fork", etc.
    #
    def name=(name)
      Valid.oneline!(name)  # should be word!
      @data[:name] = name.to_str
    end

    #
    # The repository's URI.
    #
    attr_reader :uri

    #
    # Set repository URI
    #
    def uri=(uri)
      Valid.oneline!(uri)
      #Valid.uri!(uri)  # TODO: any other limitations?
      @data[:scm] = infer_scm(uri)
      @data[:uri] = uri
    end

    #
    #
    #
    attr_reader :scm

    #
    # Set the SCM type of repository. The type is a single downcased word.
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
    def scm=(scm)
      Valid.word!(scm)
      @data[:scm] = scm.to_str.downcase
    end

    #
    # Prefix URI that can be used to link to source code.
    #
    # This name is the traditional one from a time when CVS was the
    # most popular SCM.
    #
    attr_reader :webcvs

    #
    #
    #
    def webcvs=(uri)
      Valid.oneline!(uri)
      Valid.uri!(uri)  # TODO: any other limitations?
      @data[:webcvs] = uri
    end

    # TODO: Should we rename Repository#webcvs to just #web ?

    #
    alias_method :web, :webcvs
    alias_method :web=, :webcvs=

  private

    #
    def infer_scm(uri)
      case uri
      when /^git:/, /\.git$/
        'git'
      when /^hg:/, /\.hg$/
        'hg'
      when /^svn:/
        'svn'
      when /darcs/
        'darcs'
      else
        nil
      end
    end

  end

end
