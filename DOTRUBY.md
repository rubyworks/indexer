# The .ruby Specification

## Introduction

The .ruby specification defines an very explict and detailed ...


## Fields

### Revision

The revision of .ruby specification.

    revision: 0

### Name

The "unix" name of the package. It must be a single word.

    name: hello_world

### Version

The version SHOULD follow the SemVer specification (http://semver.org/),
but it MUST be a dot separated string of alphanumeric characters.

    version: 1.0.0

### Codename

The codename is a arbitraty name given to the particular version.

    codename: Lucy Loo

### Title

The title is a arbitrary single line string, though it usually reflects
the name field captialized.

    title: Hello World

### Date

Date is the date the .ruby file was generated. Within packages this will
be effectively the date the package was released. The format is
standard ISO UTC, and may have an optional HH::MM::SS timestamp.

    date: 2011-06-02

### Created

Created is the date the project was began. The format is
standard ISO UTC. It can also have an optional HH::MM::SS timestamp.

    created: 2011-05-29

### Summary

Summary is a one-line summary description of the project.

    summary: Say hello to the world!

### Description

Description is a multi-line detailed description of the project.

    description:
      Hello World allows anyone to  say hello to the world.
      It's fun to do and easy to use.

### Authors

Authors is a list of individuals responsible for the development of 
the project. Each entry is a mapping with keys, `name`, `email`,
`website` and `role`.

    authors:
      - name:    Thomas T. Thomas
        email:   tommy@tommy.com
        website: http://tommy.net
        role:    [ developer, founder ]
      - name:    James J. James, Jr.
        email:   jimmy@jimmy.com
        website: http://jimmy.net
        role:    [ QA ]

Authors should be given in order of contact. In other words the first
person on the list is most likely to be the person to contact about
the project. Roles also help people select appropriate contacts.

### Suite

The package belongs to a suite of packages, then it can be designated
with the `suite` field.

    suite: SpecWorks

### Organization

The `organization` specifies the name of the company, club or other type
of organization to which this package is assocciated.

    organization: Spec, Inc.

### Copyrights

The Copyrights field is a list of copyrights with licensing. Each entry
has `yesr`, `holder` and `license` fields. Entries should be in the order
of signifficance. The first MUST be the primary license.

    copyrights:
      - holder: Thomas T. Thomas
        year: 2011
        license: GPL-3.0
      - holder: James J. James, Jr.
        year: 2010
        license: Apache-2.0

License entries MUST use the SPDX standard codes (http://spdx.org/licenses/)
when possible.

### Requirements

Requirements are the packages on which this package depends. Often, referred to
as _dependencies_ we have chosen instead to use the term requirements becuase
that is what Ruby actually does with them --it _requires_ them. Requirements
is an array of hashes, composed of `name`, `version`, `group`, `development`,
`repository`, `engine`, `platform` and `optional`.

    requirements:
      - name: dotruby
        version:
          - 1.0.0
        group: [build]
        development: true
        optional: false
        engine:
          - ruby 1.9+
        platform:
          - x86_64-linux
        repository:
          scm: git
          url: http://github.com/dotruby/dotruby.git

### Dependencies

Dependencies akin to requirements, but are system packages that this package
depends upon. Pacakge managers might use this information to install dependent
packages via `apt-get` or `yum`, for instance. A good example is, `ruby-libxml`
which depends on the libXML2 library. Each entry has the same format as
entries for `requirements`.

    dependencies:
      - name: libXML2
        version: 1.0+
        development: false

The development flag serves an additional purpose for a dependency,in that
it also indicates that development packages need to be available, such
as in our exmple `libxml2-dev` for Debian.

### Conflicts

Conflicts is a list of packages which have known issues when operating 
in the same process as this package. It consists of a list of mappings
for `name` and `version`.

    conflicts:
      - name: badmojo
        verison:
          - 0+

### Substitues

Substitues is simply a list of packages that more or less do the same
thing as this package. A good example is a Markdown parser:

    substitutes:
      - rdiscount
      - BlueCloth

### Replacements

TODO: Should this be called `replaces` instead?

Replacements is a list of packages that this package essentially usurps.
For example, the SlimGems pacakge might claim to be a replacement for 
RubyGems pacakge.

    replacements:
      - rubygems

### Resources

Resources is a sequence of resource id and universal resource locator (URL).

    resources:
      - id:  homepage
        url: http://foo.org
      - id:  documentation
        url: http://foo.org/doc

IMPORTANT! The thing to note about resources is that only the first 3 to 4
characters of the identifier are used to distinguish them. In other words, any
resource id that begins with the letters `doc` is considered a documentation
link. Likewise for `home`. In this way `home` is recognized as the same resource
as `homepage`.

Common recognized types are `api dev doc code home irc mail talk wiki work`

There are also a few long-term ids that are considered synonyms too.

* `source code` = `code`
* `development` = `work`

### Repositories

Repositories is a mapping of repository type to universal resource locator
for the package repository and scm type.

    repositories:
      - id: public
        url: http://github.com/fooworks/hello_world.git
        scm: git

### Load Path

The `load_path` field provides a list of paths within the project that
the load system must search when loading scripts.

    load_path:
      - lib

By default it's value is take to be `['lib']`.

### Install Message

The post install message. This field is used by package managers to inform
the installer of any important information they may need to know.

    install_message: |
      Hello World is only an example.

### Extra

Any extraneous metadata can be placed in the `extra` field as a hash entry.
This will be very rarely used.

    extra:
      need: good example

