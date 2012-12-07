module Indexer

  # Dependency class is essentially the same as {Requirement}, but
  # a dependency represents a binary package requirement that would
  # need to be installed using an operating systems own package
  # management system, or installed manually.
  #
  # Dependency is a sublcass of {Requirement}. It only exists as a separate
  # class becuase an OS package managers MIGHT require some additional
  # information --but as of yet that's not the case.
  #
  # TODO: Why not merge the two and add a field to distinguish them?
  #
  class Dependency < Requirement
  end

end

