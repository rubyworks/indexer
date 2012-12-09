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
        require 'redcarpet'

        renderer = Redcarpet::Render::HTML.new()
        markdown = Redcarpet::Markdown.new(renderer, :autolink=>true, :tables=>true, :space_after_headers=>true)
        html     = markdown.render(File.read(file))
        doc      = Nokogiri::HTML(html)

        load_html(doc)
      end

    end

    # Include mixin into Importer class.
    include MarkdownImportation

  end

end
