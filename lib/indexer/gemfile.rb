#module Indexer

  # Make sure Indexer is loaded.
  require 'indexer' unless defined?(Indexer)

  require 'bundler'

  # Bundler integration.
  #
  # This does not support Bundler's `:git` references
  # or `:require` option (at least not yet).
  #
  module Bundler

    # Mixin for Bundler::Dsl.
    #
    class Dsl

      #
      # Dynamically update a Gemfile from the `.index` file. Just call `index`
      # from your Gemfile.
      #
      #     rubyfile
      #
      # This is analogous to the Gemfile's `gemspec` method.
      #
      def index
        spec = Indexer::Metadata.open
        spec.requirements.each do |req|
          next if req.external?
          gem(req.name, req.version, :group=>req.groups)
        end
      end

      #
      def metadata
        @metadata ||= Indexer::Metadata.new
      end

      #
      alias :_method_missing :method_missing

      #
      # Evaluating on the Builder instance, allows Ruby basic metadata
      # to be built via this method.
      #
      def method_missing(s, *a, &b)
        r = s.to_s.chomp('=')
        case a.size
        when 0
          if metadata.respond_to?(s)
            return metadata.__send__(s, &b)
          end
        when 1
          if metadata.respond_to?("#{r}=")
            return metadata.__send__("#{r}=", *a)
          end
        else
          if metadata.respond_to?("#{r}=")
            return metadata.__send__("#{r}=", a)
          end
        end

        _method_missing(s, *a, &b)
        #super(s, *a, &b)  # if cases don't match-up
      end

    end

  end

#end

#::Bundler::Dsl.__send__(:include, Indexer::Bundler::Dsl)

