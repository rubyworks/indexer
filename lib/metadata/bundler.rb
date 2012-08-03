require 'bundler'

module Metadata

  # Bundler integration.
  #
  # The metaspec does not support Bundler's `:git` references
  # or `:require` option (at least not yet).
  #
  module Bundler

    ##
    ## Dynamically update a Gemfile from the .meta.
    ##
    #def self.metaspec(gemfile, spec=nil)
    #  spec = spec || Spec.find
    #
    #  spec.requirements.each do |name, req|
    #    gemfile.gem(req.name, req.version, :group=>req.groups)
    #  end
    #end

    # Mixin for Bundler::Dsl.
    #
    module Dsl
      #
      # Dynamically update a Gemfile from the .meta. Just call `metaspec`
      # from your Gemfile.
      #
      #     metaspec
      #
      # This is analogous to the Gemfile's `gemspec` method.
      #
      def metaspec
        spec = Metadata.find  #Meta::Spec.find

        spec.requirements.each do |name, req|
          gem(req.name, req.version, :group=>req.groups)
        end
      end
    end

  end

end

::Bundler::Dsl.__send__(:include, Metadata::Bundler::Dsl)

