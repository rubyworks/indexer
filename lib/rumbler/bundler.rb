module Rumbler

  require 'bundler'

  # Bundler integration.
  #
  # This does not support Bundler's `:git` references
  # or `:require` option (at least not yet).
  #
  module Bundler

    ##
    ## Dynamically update a Gemfile from the .meta.
    ##
    #def self.rubyfile(gemfile, spec=nil)
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
      # Dynamically update a Gemfile from the `.ruby`. Just call `rubyfile`
      # from your Gemfile.
      #
      #     rubyfile
      #
      # This is analogous to the Gemfile's `gemspec` method.
      #
      def rubyfile
        spec = Metadata.open

        spec.requirements.each do |name, req|
          gem(req.name, req.version, :group=>req.groups)
        end
      end
    end

  end

end

::Bundler::Dsl.__send__(:include, Rumbler::Bundler::Dsl)

