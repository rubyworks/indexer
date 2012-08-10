module Rumbler

  class Author
    def self.v(revision)
      V[revision || REVISION]::Author
    end
  end

  class Copyright
    def self.v(revision)
      V[revision || REVISION]::Copyright
    end
  end

  class Conflict
    def self.v(revision, *args, &blk)
      V[revision || REVISION]::Conflict
    end
  end

  class Resources
    def self.v(revision)
      V[revision || REVISION]::Resources
    end
  end

  class Repository
    def self.v(revision, *args, &blk)
      V[revision || REVISION]::Repository
    end
  end

  class Requirement
    def self.v(revision, *args, &blk)
      V[revision || REVISION]::Requirement
    end
  end

  class Dependency
    def self.v(revision=nil)
      V[revision || REVISION]::Dependency
    end
  end

end
