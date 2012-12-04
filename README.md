# <span class="ititle">Indexer</span> (v<span class="iversion">0.1.0</span>)

<b class="isummary">Enable Your Project's Metadata<b>

[![Build Status](https://secure.travis-ci.org/rubyworks/indexer.png)](http://travis-ci.org/rubyworks/indexer)

<p class="idescription">Indexer gives developers a unified data format for reusable project metadata.</p>

Indexer defines a *canonical*, detailed and strict, project <span class="icategory">metadata</span> specification.
The strictness of the specification makes the format simple enough for developers to use without an intermediate API.
Although Indexer also provides a convenience API for working with the specification and its data 
more loosely when suitable to the usecase. Indexer also specifies a stanadard location for canonized
metadata to be kept, in a `.index` file.

Indexer provides a tool to import metadata from external sources. Indexer can handle a variety of metadata
source formats, including YAML, HTML Micorformat and Ruby DSL scripts.


## Resources

<ul>
<li><a class="iresource" href="http://rubyworks.github.com/indexer" name="home">Homepage</a></li>
<li><a class="iresource" href="http://github.com/rubyworks/indexer" name="code">Source Code</a> (Github)</li>
<li><a class="iresource" href="http://rubydoc.info/gems/indexer/frames" name="docs">API Reference</a></li>
</ul>

## Requirements

<ul>
<li class="irequirement">
  <a class="name" href="http://nokogiri.org/">nokogiri</a> <span class="version">1.5+</span></span>
</li>
<li class="irequirement">
  <a class="name" href="https://github.com/vmg/redcarpet">redcarpet</a> <span class="version">2.2+</span></span>
</li>
<li class="irequirement">
  <a class="name" href="http://rubyworks.github.com/qed/">qed</a> <span class="version">2.9+</span> <span class="groups">(test)</span>
</li>
<li class="irequirement">
  <a class="name" href="http://rubyworks.github.com/ae/">ae</a> <span class="version"></span> <span class="groups">(test)</span>
</li>
</ul>

## Authors

<ul>
<li class="vcard iauthor">
  <div class="nickname">trans</div>
  <div><a class="email" href="mailto:transfire@gmail.com">transfire@gmail.com</a></div>
  <div><a class="url" href="http://trans.gihub.com/">http://trans.github.com/</a></div>
</li>
<li class="vcard iauthor">
  <div class="nickname">postmodern</div>
  <div><a class="url" href="http://postmodern.github.com/">http://postmodern.github.com/</a></div>
</li>
</ul>

## Copyrights

<ul>
<li class="icopyright">
  &copy; <span class="year">2012</span> <span class="holder">Rubyworks</span>
  <div class="license">
    <a href="http://www.spdx.org/licenses/BSD-2-Clause" rel="license">BSD-2-Clause License</a>
  </div>
</li>
<ul>

