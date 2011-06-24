module DotRuby
  module V0
    # The Repository class models a packages SCM repository location.
    # It consists of two parts, the `scm` type of repository, it's `url`.
    #
    class Repository

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
          new('url'=>data)
        when Array
          h, d = {}, data.dup  # TODO: data.rekey(&:to_s)
          h.update(d.pop) while Hash === d.last
          h['id']  = d.shift unless d.empty?
          h['url'] = d.shift unless d.empty?
          h['scm'] = d.shift unless d.empty?
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
        data.each do |field, value|
          send("#{field}=", value)
        end

        self.scm = infer_scm(url) unless scm
      end

      #
      # The id of the repository.
      #
      attr_reader :id

      #
      # Set the repositoru id. This can be any one line description but
      # it generally should be a brief one-word indictor such as "public",
      # "master", "expiremental", etc.
      #
      def id=(id)
        Valid.oneline!(id)
        @id = id.to_str
      end

      #
      # The repository's public URL.
      #
      attr_reader :url

      #
      # Set repository URL>
      #
      def url=(url)
        Valid.url!(url)
        @url = url.to_s
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
        @scm = scm.to_str.downcase
      end

      private

      #
      def infer_scm(url)
        case url
        when /^git:/, /\.git$/
          'git'
        when /^hg:/, /\.hg$/
          'hg'
        when /^svn:/
          'svn'
        else
          nil
        end
      end

    end
  end
end
