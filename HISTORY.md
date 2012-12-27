# RELEASE HISTORY

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
