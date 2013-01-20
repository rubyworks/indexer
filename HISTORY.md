# RELEASE HISTORY

## 0.3.0 / 2012-01-19

The 0.3 release makes three significant improvements. First, instead of
using `paths['load']` for the Ruby load path setting, it designates the use
of `paths['lib']`. In this manner the keys of the paths field can be generally
based on standard locations in a project, and more generally on FHS. Secondly,
this release also removes the `extra` field. Instead custom entries can be added
at the root of the document. Note that this means that parts of the API may
return `nil` instead of raising an error when queried for an undefined field.
To ensure that metadata van still be strongly validated the specification adds
a `customs` field where the names of custom fields are specified.

Changes:

* Designate `paths['lib']` for Ruby's load path, instead of `paths['load']`.
* Remove `extra` field from specification; custom fields can be in root not.
* Add `customs` field to allow customization in a robust manner.


## 0.2.0 / 2012-12-27

The `load_path` field has been deprecated and replaced with the `paths` field,
which holds a mapping of names to local path locations within the project. This
makes identifying paths completely generic. For Ruby projects use the 'load' entry.

This release also makes Kramdown the fallback for importing microformat data from 
markdown documents if Redcarpet is not available. This makes it usable with JRuby.
(Kramdown may become the only support markdown render in the future.)

Changes:

* Deprecate `load_path` array in favor of `paths` hash.
* Support Kramdown as fallback Markdown renderer.
* Add requirement optional field support to microformat importer.


## 0.1.0 / 2012-12-09

Initial release of Indexer.

Changes:

* All of them ;)
