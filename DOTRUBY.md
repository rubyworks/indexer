# .ruby spec


## Fields

### Name

The "unix" name of the package. It must be a single word.

    name: hello_world

### Version

The Version must follow (or at very nearly follow) the semver specification
(http://semver.org/).

    version: 1.0.0

### Codename

The Codename is a arbitraty name given to the particular version.

    codename: Lucy Loo

### Title

The title is a single line string.

    title: Hello World

### Authors

Authors list the originating authors of a project. They are usually
the primary copyright holders.

    authors:
      - name: Thomas T. Thomas
        email: tommy@tommy.com
        website: http://tommy.net

### Maintainers

Maintainers are the individuals currently developing a project.

    maintainers:
      - name: Thomas T. Thomas
        email: tommy@tommy.com
        website: http://tommy.net

### Suite

The package belongs to a suite of packages, then it can be designated
with the `suite` field. This is somtimes identical to organization.

    suite: SpecWorks

### Company / Organization

The `company` (or `organization`?) specifies the name of the company or
orgnaization which which this package is assocciated.

    company: Spec, Inc.

### Copyright

The Copyright is an abribtrate string containing the projects copyright
notice. DO NOT include license information in this.

  copyright: |
    (c) 2011 Thomas T. Thomas
    (c) 2010 James J. James

### Requirements

Requirements are the packages on which this package depends. Often, referred to
as _dependencies_ we have chosen instead the use the term requirements becuase
that is what the package actually does with them --it _requires_ them.

    requirements:
      dotruby:
        version: 1.0.0
        runtime: false
        groups: [build]

NOTE: If we don't like this design of a "detail hash", and would rather
a simple version hash, then we will have to have a separate field and
it would have to use a group designation to determine runtime vs
development, e.g.

    requirements:
      facets: 2.9+
      dotruby: 1.0.0

    requirement_groups:
      facets: []  # or  [runtime]
      dotruby: [build]


### Conflicts

Conflicts is a list of packages which have known issues when operating 
in the same process as this package.

  conflicts:
    badmojo: 0+

### Replacements

Replacements is simply a list of packages that more or less do the same
thing as this package. A good example is a Markdown parser:

  replacements:
    - rdiscount
    - BlueCloth

### External Requirements

External requirements are arbitrary dependencies outside the scope of
a package manager.

    external_requirements:
      - "libXML2 1.0+"
      - "fast graphics card"

### Resources

Resources is a mapping of resource type to universal resource locator (URL).

    resources:
      homepage: http://
      documentation: http://

One important thing to note about resources is that onlt the first 3 to 4
characters of the type are used to distinguish types. In other words, any
resource type that begins with the letters `doc` is considered a documentation
link. Likewise for `home` and a few others.

### Repositories

Repositories is a mapping of repository type to universal resource locator
for the package repository.

    repositories:
      public: http://github.com/fooworks/hello_world.git

### Extra

Any extraneous metadata can be placed in the `extra` field as a hash entry.
This will be very rarely used.

    extra:
      need: good example


