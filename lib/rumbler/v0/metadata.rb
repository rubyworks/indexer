module Rumbler; module V0

  class Metadata < Base

    #
    include Conventional

    # Load metadata, ensuring canoncial validity.
    #
    # @param [String] file
    #   The file name from which to read the YAML metadata.
    #
    def self.valid(data)
      valid_data = Validator.new(data).to_h
      new(valid_data)
    end

    #
    # Create a new Meta::Spec given a Gem::Specification or .gemspec file.
    #
    # @param [Gem::Specification,String] gemspec
    #   RubyGems Gem::Specification object or path to .gemspec file.
    #
    def self.from_gemspec(gemspec)
      new.import_gemspec(gemspec)
    end

    # Create nicely formated project "about" text.
    #
    # @return [String] Formatted about text.
    #
    def about(*parts)
      s = []
      parts = [:header, :description, :resources, :copyright] if parts.empty?
      parts.each do |part|
        case part.to_sym
        when :header
          s << "%s %s (%s-%s)" % [title, version, name, version]
        when :title
          s << title
        when :package
          s << "%s-%s" % [name, version]
        when :description
          s << description || summary
        when :summary
          s << summary
        when :resources
          s << resources.map{ |resource|
            "%s: %s" % [resource.label || resource.type, resource.uri]
          }.join("\n")
        when :repositories
          s << repositories.map{ |repo|
            "%s" % [repo.uri]
          }.join("\n")
        when :copyright, :copyrights
          s << copyrights.map{ |c|
            "Copyright (c) %s %s (%s)" % [c.year, c.holder, c.license]
          }.join("\n")
        else
          s << __send__(part)
        end
      end
      s.join("\n\n")
    end

    # Save `.meta` file.
    #
    # @param [String] file
    #   The file name in which to save the metadata as YAML.
    #
    def save!(file='.meta')
      v = Validator.new(to_h)
      v.save!(file)
    end

  end

end; end
