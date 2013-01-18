# RELEASE HISTORY

## 0.3.0 / 2012-01-19

Instead of using `paths['load']` for Ruby load path settings, use `paths['lib']`.
In this manner the keys of the paths field can be generally based on standard
locations in a project, and more generally on FHS. This release also removes the
`extra` fields. Instead custom entries can be added at the root. Note that this 
means that parts of the API will return `nil` instead of rasing an error when
queried for a undefined field.

Changes:

* Designate `paths['lib']` for Ruby's load path, instead of `paths['load']`.
* Remove `extra` field from specification.


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
