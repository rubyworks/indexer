[![Build Status](https://secure.travis-ci.org/rubyworks/indexer.png)](http://travis-ci.org/rubyworks/indexer)
[![Gem Version](https://badge.fury.io/rb/indexer.png)](http://badge.fury.io/rb/indexer)

<br/>


# Indexer

*Enable Your Project's Metadata*


## Description

Indexer provides projects with a universal metadata format.

Indexer defines a *canonical*, detailed and strict, project metadata specification.
The strictness of the specification makes the format simple enough for developers to use without an intermediate API.
Although Indexer also provides a convenience API for working with the specification and its data 
more loosely when suitable to the usecase. Indexer also specifies a stanadard location for canonized
metadata to be kept, in a `.index` file.

Indexer provides a tool to import metadata from external sources. Indexer can handle a variety of metadata
source formats, including YAML, HTML Microformats and Ruby DSL scripts.


## Installation

Indexer is a Ruby application, so as long as you have Ruby installed, it is easy to install Indexer via RubyGems.

    $ gem install indexer


## Instruction

Indexer is capable of generating a canonical `.index` file from a variety of sources. Being so flexiable, exactly
how a developer descides to store a project's metadata is a largely a matter of taste. But in general there are
three overall approaches:

1. Specify the metadata using microformats in a project's README file.
2. Specify the metadata in one or more static files, often a single YAML file.
3. Construct the metadata via a Ruby DSL, customizing the generation in any way.

The first choice is, in many respects, the nicest because it does not require any additional files be added
to a project and it helps to ensure a good README file. On the downside, it requires some HTML be hand-coded
into the README.

The second approach is a great option in the it is the easiest. One can quickly put together a YAML document
covering a project's metadata. Since Indexer is very flexible in it's parsing of the YAML, it really is a
quick and user-friendly way to go. Typically this file will be called `Index.yml`, but there is no name
requirement. In fact, Indexer will let you split the metadata up over mutliple files, and even use a whole
directory of files, one per field.

The last approach provides maximum flexablity. Using the Ruby DSL one can literally script the metadata,
which means it can come from anywhere at all. For example, you might want to pull the project's version
from the `lib/project/version.rb` file, i.e. Bundler style. The DSL is as intutive and as flexible as 
using plain YAML, so it's nearly as easy to take this approach. By convention this file is called `Indexfile`
or `Index.rb`, but it too can be any file path one prefers.

On the Indexer wiki you can find detailed tutorials on a variety of setups, along with thier pros and cons.

As an example of getting started, lets say we want to customize our index metadata via a YAML file,
but we want to keep the version information is a separate `VERSION` file. That's a common layout so Indexer
is designed to handle it out of the box. First create the `VERSION` file.

    $ echo '0.1.0' > VERSION

Next we need our YAML file. Indexer makes out life easier by offering us some template generation for 
common approaches. In this case we use the `-g/--generate` command option, specifying that we want an
`Index.yml`.

    $ index --generate Index.yml

Now we can edit the `Index.yaml` file to suite our project.

    $ vim Index.yml

Once we have the source files setup, its easy to build the canonical `.index` file using the `index` 
command line interface. We can simply issue the `index` command with the `-u/--using` command option:

    $ index --using VERSION Index.yml

Indexer will utilize both sources and create the `.index` file.

Over time project metadata tends to evolve and change. To keep the canoncial `.index` file up to date simply
call the `index` command without any options.

    $ index

By default the `.index` file will not be updated if it has a modification time newer than its source files.
If need be, use the `-f/--force` option to override this.

That's the quick "one two". For more information on using Indexer, see the Wiki, API documentation, QED specifications
and the Manpages.


## Resources

* [Website](http://rubyworks.github.com/indexer)
* [Source Code](http://github.com/rubyworks/indexer) (Github)
* [API Guide](http://rubydoc.info/gems/indexer/frames)
* [Master Git Repo](http://github.com/rubyworks/indexer/indexer.git)


## Requirements

* [nokogiri](http://nokogiri.org/) 1.5+
* [kramdown](http://kramdown.rubyforge.org/) 0.14+
* [redcarpet](https://github.com/vmg/redcarpet) 2.0+ (optional)
* [qed](http://rubyworks.github.com/qed/) 2.9+ (test)
* [ae](http://rubyworks.github.com/ae/) (test)


## Authors

<ul>
<li class="iauthor vcard">
  <div class="nickname">trans</div>
  <div><a class="email" href="mailto:transfire@gmail.com">transfire@gmail.com</a></div>
  <div><a class="url" href="http://trans.gihub.com/">http://trans.github.com/</a></div>
</li>
<li class="iauthor vcard">
  <div class="nickname">postmodern</div>
  <div><a class="url" href="http://postmodern.github.com/">http://postmodern.github.com/</a></div>
</li>
</ul>


## Copyrights

Indexer is copyrighted open-source software.

**&copy; 2012 Rubyworks**

It can be modified and redistributed in accordance with the terms
of the [BSD-2-Clause](http://www.spdx.org/licenses/BSD-2-Clause) license.

