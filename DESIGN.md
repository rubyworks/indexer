# DESIGN PRINCIPLES


## Strongly Revisioned

Indexer's specification for project/package metadata is <i>strongly revisioned</i>.
If the specification should ever need to change, the reimplementation for the
revised specification is _sequestored_ to it's own codeset.

The revision number is a mandatory field of the `.index` file. When a `.index` file
is parsed the revision number determines what codeset is used to handle it.

Looking at the source code the revisioning can be seen clearly by the presence
of the `lib/indexer/v0` directory. Under it lies all the classes and modules
that model the baseline Indexer specification. Very little of the code lies
outside of this directory. Only code that cannot in any way effect the formal
specification may do so. And while there may be bits of revisioned code that
may for all practical purposes fit the bill, it is better to error on the side
revisioning than not the revisioning.


### 100% Code Coverage

Becuase of the nature of .index, reliability in the specification is of the
upmost importance. While there are no perfect metrics to ensure behvior under
all circumstances, there are a few stragegies available to us that can help.
One of those is code coverage.


