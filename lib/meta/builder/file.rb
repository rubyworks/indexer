module Metadata

  class Builder
  
    # Build .meta spec from individual files.
    #
    module FileBuild

      #
      # Files build procedure.
      #
      def build(source)
        if File.directory?(source)
          load_directory(source)
          true
        else
          super(source) if defined?(super)
        end
      end

      #
      # Import files in a given directory. This will only import files
      # that have a name corresponding to a spec attribute, unless
      # the file is listed in a `.metaextra` file within the directory.
      #
      # However, files with an extension of `.yml` or `.yaml` will be loaded
      # wholeclothe and not as a single attribute.
      #
      # @todo Subdirectories are simply omitted. Maybe do otherwise in future?
      #
      def load_directory(folder)
        if File.directory?(folder)
          extra = []
          extra_file = File.join(folder, '.metaextra')
          if File.exist?(extra_file)
            extra = File.read(extra_file).split("\n")
            extra = extra.collect{ |pattern| pattern.strip  }
            extra = extra.reject { |pattern| pattern.empty? }
            extra = extra.collect{ |pattern| Dir[File.join(folder, pattern)] }.flatten
          end
          files = Dir[File.join(folder, '*')]
          files.each do |file|
            next if File.directory?(file)
            name = File.basename(file).downcase
            next load_yaml(file) if %w{.yaml .yml}.include?(File.extname(file))
            next load_field_file(file) if extra.include?(name)
            next load_field_file(file) if @spec.attributes.include?(name.to_sym)
          end
        end
      end

      #
      # Import a field setting from a file.
      #
      # TODO: Ultimately support JSON and maybe other types, and possibly
      # use mime-types library to recognize them.
      #
      def load_field_file(file)
        if File.directory?(file)
          # ...
        else
          case File.extname(file).downcase
          when '.yaml', '.yml'
            name = File.basename(file).downcase
            name = name.chomp('.yaml').chomp('.yml')
            @spec[name] = YAML.load_file(file)
            #@spec.merge!(YAML.load_file(file))   # TODO: should yaml files with explict extension by merged instead?
          when '.text', '.txt'
            name = File.basename(file).downcase
            name = name.chomp('.text').chomp('.txt')
            text = File.read(file)
            @spec[name] = text.strip
          else
            text = File.read(file)
            if /\A---/ =~ text
              name = File.basename(file).downcase
              @spec[name] = YAML.load(text)
            else
              name = File.basename(file).downcase
              @spec[name] = text.strip
            end
          end
        end
      end

    end #module FileBuild

    # Include FileBuild mixin into Builder class.
    include FileBuild

  end

end
