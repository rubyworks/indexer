module DotRuby
  module V0
    # A resource encapsulates information about a URI related to a project.
    #
    class Resource < Model

      # Parse `data` returning a new Resource instance.
      #
      # @param data [String,Array<String>,Array<Hash>,Hash]
      #   Resource information.
      #
      # @return [Resource] resource instance
      def self.parse(data)
        case data
        when String
          new('uri'=>data)
        when Array
          h, d = {}, data.dup  # TODO: data.rekey(&:to_s)
          h.update(d.pop) while Hash === d.last
          h['name'] = d.shift unless d.empty?
          h['uri']  = d.shift unless d.empty?
          h['type'] = d.shift unless d.empty?
          new(h)
        when Hash
          new(data)
        else
          raise(ValidationError, "not a valid resource")
        end
      end

      #
      # Initialize new Resource instance.
      #
      def initialize(data={})
        data.each do |field, value|
          send("#{field}=", value)
        end
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
        @type = infer_type(name) unless @type
        @name = name.to_str
      end

      #
      # The repository's URI.
      #
      attr_reader :uri

      #
      # Set repository URI
      #
      def uri=(uri)
        #Valid.oneline!(uri)
        Valid.uri!(uri)  # TODO: any other limitations?
        @type = infer_type(uri) unless @type
        @uri  = uri
      end

      #
      #
      #
      attr_reader :type

      #
      # Set the type of the resource. The type is a single downcased word.
      # It can be anything but generally recognized types are:
      #
      # * bugs, issues
      # * mail, email
      # * chat, irc
      # * home, homepage, website
      # * work, code
      #
      def type=(scm)
        Valid.word!(scm)
        @type = type.to_str.downcase
      end

      #
      # Convert resource to Hash.
      #
      # @return [Hash]
      #
      def to_h
        h = {}
        h['uri']  = uri
        h['name'] = name if name
        h['type'] = type if type
        h
      end

    private

      #
      # @todo Deciding on a set of recognized types and inferences for them is rather tricky.
      #   Some sort of guiding design principle would be helpful.
      #
      def infer_type(string)
        case string.to_s.downcase
        when /work/, /dev/
          'work'
        when /code/, /source/
          'code'
        when /bugs/, /issue/, /tracker/
          'bugs'
        when /mail/, /list/
          'mail'
        when /chat/, /irc/
          'chat'
        when /forum/, /support/, /q\&a/
          'q&a'
        when /wiki/, /user/
          'wiki'
        when /blog/, /weblog/
          'blog'
        when /home/, /website/
          'home'
        when /gem/, /pacakge/, /dist/, /download/
          'dist'
        when /api/, /reference/, /guide/
          'api'
        when /doc/
          'docs'
        else
          nil
        end
      end

    end
  end
end
