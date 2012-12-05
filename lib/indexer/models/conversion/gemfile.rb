module Indexer

  module Conversion

    #
    # Update Spec with a Gemfile.
    #
    # @param [nil,String,::Bundler::DSL,::Bundler::Definition]
    #   Gemfile path, Bundler::Dsl or Bundler::Definition instance.
    #
    def import_gemfile(file=nil)
      require 'bundler'

      case file
      when String
        # FIXME: Is this the correct way fot load a gemfile?
        bundle = ::Bundler::Dsl.new
        bundle.eval_gemfile(file)
      when NilClass
        bundle = ::Bundler.definition
      end

      begin
        merge!(bundle.metadata.to_h)
      rescue
      end

      bundle.dependencies.each do |d|
        add_requirement(d.name,
          :version     => d.requirement.to_s,  # may need to parse this
          :groups      => d.groups,
          :development => (d.type == :development)
          #:engines    => d.platforms ?
          #:platforms  => ?
        )
      end
    end

    alias_method :gemfile, :import_gemfile

  end

end

