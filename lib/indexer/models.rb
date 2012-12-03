module Indexer

  class Model
    def self.r(revision)
      Class.new(self) do
        include const_get("V%s" % [revision || REVISION])
      end
    end
  end

  class Author < Model
    #def self.v(revision)
    #  V[revision || REVISION]::Author
    #end
  end

  class Company < Model
    #def self.v(revision)
    #  V[revision || REVISION]::Author
    #end
  end

  class Conflict < Model
    #def self.v(revision, *args, &blk)
    #  V[revision || REVISION]::Conflict
    #end
  end

  class Copyright < Model
    #def self.v(revision)
    #  V[revision || REVISION]::Copyright
    #end
  end

  class Resource < Model
    #def self.v(revision)
    #  V[revision || REVISION]::Resource
    #end
  end

  class Repository < Model
    #def self.v(revision, *args, &blk)
    #  V[revision || REVISION]::Repository
    #end
  end

  class Requirement < Model
    #def self.v(revision, *args, &blk)
    #  V[revision || REVISION]::Requirement
    #end
  end

  #class Dependency < Model
    #def self.v(revision=nil)
    #  V[revision || REVISION]::Dependency
    #end
  #end

end
