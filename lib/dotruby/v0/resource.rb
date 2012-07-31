module DotRuby
  module V0
    # A resource encapsulates information about a URI related to a project.
    #
    # TODO: This model is a little tricky b/c it's difficult to settle on a standard
    # set of types or labels. It is also difficult to determine if label's and types
    # should in fact be infered or just left empty if not provided. Any insight welcome!
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
          args = h.keys.map{ |k| k.to_s } - ['uri', 'type', 'label']
          args.each do |key|
            case key
            when 'uri'
              if u = d.find{ |e| Valid.uri?(e) }
                h['uri'] = d.delete(u)
              end
            when 'type'
              if t = d.find{ |e| Valid.word?(e) && e.downcase == e }
                h['type'] = d.delete(t)
              end
            when 'label'
              h['label'] = d.shift
            end
            raise ValidationError, "malformed resource -- #{data.inspect}" unless d.empty?
          end
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
        data = data.rekey(&:to_sym)

        ## best to assign in this order
        self.uri   = data.delete(:uri)
        self.type  = data.delete(:type) if data.key?(:type)

        data.each do |field, value|
          send("#{field}=", value)
        end
      end

      #
      # A label that can be used to identify the purpose of a
      # particular repository.
      #
      attr_reader :label

      #
      # Set the resource name. This can be any brief one line description.
      #
      # Examples
      #
      #   resource.label = "Homepage"
      #
      def label=(label)
        Valid.oneline!(label)  # should be word!
        @type  = infer_type(label) unless @type
        @label = label.to_str
      end

      #
      # Alias for #label.
      #
      alias :name :label
      alias :name= :label=

      #
      # The repository's URI.
      #
      attr_reader :uri

      #
      # Set repository URI
      #
      def uri=(uri)
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
      def type=(type)
        Valid.word!(type)
        @label = infer_label(type) unless @label
        @type  = type.to_str.downcase
      end

      #
      # Convert resource to Hash.
      #
      # @return [Hash]
      #
      def to_h
        h = {}
        h['uri']   = uri
        h['label'] = label if label
        h['type']  = type  if type
        h
      end

      #
      # Recognized types and the default labels that do with them.
      #
      TYPE_LABELS = {
        'work'    => "Development",
        'dev'     => "Development",
        'code'    => "Source Code",
        'bugs'    => "Issue Tracker",
        'issues'  => "Issue Tracker",
        'mail'    => "Mailing List",
        'list'    => "Mailing List",
        'forum'   => "Support Forum",
        'support' => "Support Forum",
        'faq'     => "Fact Sheet",
        'home'    => "Website",
        'web'     => "Website",
        'blog'    => "Blog",
        'pkg'     => "Download",
        'dist'    => "Download",
        'api'     => "API Guide",
        'irc'     => "IRC Channel",
        'chat'    => "IRC Channel",
        'doc'     => "Documentation",
        'docs'    => "Documentation",
        'wiki'    => "User Guide"
      }

      #
      #
      #
      KNOWN_TYPES = TYPE_LABELS.keys

    private

      #
      #
      #
      def infer_label(type)
        TYPE_LABELS[type.to_s.downcase] 
      end

      #
      # @todo Deciding on a set of recognized types and inferences for them is rather tricky.
      #   Some sort of guiding design principle would be helpful.
      #
      def infer_type(string)
        case string.to_s.downcase
        when /work/i, /dev/i
          'dev'  #'development'
        when /code/i, /source/i
          'code' #'source-code'
        when /bugs/i, /issue/i, /tracker/i
          'bugs' #'issue-tracker'
        when /mail/i, /list/i
          'mail' #'mailing-list'
        when /chat/i, /irc/i
          'chat' #'online-chat'
        when /forum/i, /support/i, /q\&a/i
          'help' #'support-forum'
        when /wiki/i, /user/i
          'wiki' #'wiki-wiki'
        when /blog/i, /weblog/i
          'blog' #'weblog'
        when /home/i, /website/i
          'home' #'homepage'
        when /gem/i, /packge/i, /dist/i, /download/i
          'dist' #'package' or 'distribution' ?
        when /api/i, /reference/i, /guide/i
          'api'  #'reference' ???
        when /doc/i
          'doc' #'documentation'
        else
          nil
        end
      end

    end
  end
end
