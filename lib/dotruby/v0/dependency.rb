# The Dependency class requires Repository.
if RUBY_VERSION > '1.9'
  require_relative 'repository'
  require_relative 'requirement'
else
  require 'dotruby/v0/repository'
  require 'dotruby/v0/requirement'
end

module DotRuby
  module V0
    # Dependency class is essentially the same as {Requirement}, but
    # a dependency represents a binary package requirement that would
    # need to be installed using a operating systems own package
    # management system, or installed manually.
    #
    # Dependency is a sublcass of {Requirement}. It only exists as a separate
    # class becuase a OS package managers MIGHT require some additional
    # information --but as of yet that's not the case.
    class Dependency < Requirement
    end

  end
end
