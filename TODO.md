# TODO LIST

## Importer Design

Currently the Importer uses modules and inheritance chain to apply
different types of importers in order (via super call). This is 
kind of a weird way to do it. A more proper approach would probably 
be to use a class for each type of importer (or a at least a self extend
module) and register them in proper order. Then the Importer would just
run through the list until one succeeds.


