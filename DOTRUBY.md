# .ruby spec

## Introduction

The .ruby file specification defines an very explict and detail...


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

Authors is a lists the originating authors of a project. They are
usually the copyright holders. Each entry is a mapping with keys,
`name`, `email` and `website`.

    authors:
      - name: Thomas T. Thomas
        email: tommy@tommy.com
        website: http://tommy.net

### Maintainers

Maintainers is a list of individuals currently developing a project.
Each entry is same as with authors.

    maintainers:
      - name: Thomas T. Thomas
        email: tommy@tommy.com
        website: http://tommy.net

### Suite

The package belongs to a suite of packages, then it can be designated
with the `suite` field. This is somtimes identical to organization.

    suite: SpecWorks

### Organization

The `organization` specifies the name of the company, club or other type
of organization to which this package is assocciated.

    organization: Spec, Inc.

### Copyright

The Copyright is an abribtrate string containing the projects copyright
notice. DO NOT include license information in this.

    copyright: |
      (c) 2011 Thomas T. Thomas
      (c) 2010 James J. James, Jr.


### Licenses

Licenses is a list licenses the package is distributed under. The first
MUST be the primary license. The names should be the short representations
the licenses with a version number if it applies.

    licenses:
      - GPL3
      - Apache 2.0
      - MIT

### Requirements

Requirements are the packages on which this package depends. Often, referred to
as _dependencies_ we have chosen instead to use the term requirements becuase
that is what Ruby actually does with them --it _requires_ them. Requirements
is an array of hashes, composed of name, version, groups, development, engine
and platform.

    requirements:
      - name: dotruby
        version: 1.0.0
        groups: [build]
        development: true

### Conflicts

Conflicts is a list of packages which have known issues when operating 
in the same process as this package.

    conflicts:
      - name: badmojo
        verison: 0+

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

### Dependencies

Dependencies akin to requirements, but are system packages that this package
depends upon. Pacakge managers might use this information to install dependent
packages via `apt-get` or `yum`, for instance. A good example is, `ruby-libxml`
which depends on the libXML2 library.

    dependencies:
      - name: libXML2
        version: 1.0+

### External Requirements

TODO: Do we really need this? If it's that important put it in the install_message.

External requirements are arbitrary needs that lie outside the scope of any
package manager.

    external_requirements:
      - "fast graphics card"

### Resources

Resources is a mapping of resource type to universal resource locator (URL).

    resources:
      homepage: http://foo.org
      documentation: http://foo.org/doc

IMPORTANT! The thing to note about resources is that only the first 3 to 4
characters of the type are used to distinguish them. In other words, any
resource type that begins with the letters `doc` is considered a documentation
link. Likewise for `home`. In this way `home` is recognized as the same resource
as `homepage`.

Recognized types are `api dev doc code home irc mail talk wiki work`

There are also a few non-conforming types that are considered synonyms.

  `source code` = `code`
  `development` = `work`

### Repositories

Repositories is a mapping of repository type to universal resource locator
for the package repository.

    repositories:
      public: http://github.com/fooworks/hello_world.git

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

