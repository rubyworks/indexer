module Rumbler

  class Author
    def self.v(revision)
      V[revision || CURRENT_REVISION]::Author
    end
  end

  class Copyright
    def self.v(revision)
      V[revision || CURRENT_REVISION]::Copyright
    end
  end

  class Conflict
    def self.v(revision, *args, &blk)
      V[revision || CURRENT_REVISION]::Conflict
    end
  end

  class Resources
    def self.v(revision)
      V[revision || CURRENT_REVISION]::Resources
    end
  end

  class Repository
    def self.v(revision, *args, &blk)
      V[revision || CURRENT_REVISION]::Repository
    end
  end

  class Requirement
    def self.v(revision, *args, &blk)
      V[revision || CURRENT_REVISION]::Requirement
    end
  end

  class Dependency
    def self.v(revision=nil)
      V[revision || CURRENT_REVISION]::Dependency
    end
  end

end
