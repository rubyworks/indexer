module Indexer

  class Importer

    # Import metadata from a markdown source.
    #
    module MarkdownImportation

      #
      # Markdown import procedure.
      #
      def import(source)
        if File.file?(source)
          case File.extname(source)
          when '.md', '.markdown'
            load_markdown(source)
            return true
          end
        end
        super(source) if defined?(super)
      end

      #
      # Import metadata from HTML file.
      #
      def load_markdown(file)
        require 'nokogiri'

        text = File.read(file)

        begin
          require 'redcarpet'
          html = render_with_redcarpet(text)
        rescue LoadError
          require 'kramdown'
          html = render_with_kramdown(text)
        end

        doc = Nokogiri::HTML(html)

        load_html(doc)
      end

      #
      def render_with_redcarpet(text)
        renderer = Redcarpet::Render::HTML.new()
        markdown = Redcarpet::Markdown.new(renderer, :autolink=>true, :tables=>true, :space_after_headers=>true)
        markdown.render(text)
      end

      #
      def render_with_kramdown(text)
        Kramdown::Document.new(text).to_html
      end

    end

    # Include mixin into Importer class.
    include MarkdownImportation

  end

end
