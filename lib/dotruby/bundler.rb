require 'bundler'

module DotRuby

  # Bundler integration for DotRuby.
  #
  # The .ruby spec does not support Bundler's `:git` references
  # or `:require` option (at least not yet).
  #
  module Bundler

    ##
    ## Dynamically update a Gemfile from the .ruby.
    ##
    #def self.dotruby(gemfile, spec=nil)
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
      # Dynamically update a Gemfile from the .ruby. Just call `dotruby`
      # from your Gemfile.
      #
      #   dotruby
      #
      # This is analogous to the Gemfile's `gemspec` method.
      #
      def dotruby
        spec = DotRuby::Spec.find

        spec.requirements.each do |name, req|
          gem(req.name, req.version, :group=>req.groups)
        end
      end
    end

  end

end

::Bundler::Dsl.__send__(:include, DotRuby::Bundler::Dsl)

