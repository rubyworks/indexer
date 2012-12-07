## Indexer::Metadata#namespace

The namespace field is toplevel module or class name of the project's API.
For example, if the project uses `module Foo` to encapsulate it's 
functionality, than the namespace would be "Foo".

    spec = Indexer::Metadata.new

    spec.namespace = "Foo"

The namespec must be a vaild constant name, and it may contain `::`.

