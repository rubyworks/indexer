module DotRuby

  # First revision of dotruby specification.
  module V0

    # The Attributes module defines all of the accepted metadata fields.
    module Attributes

      # The revision of .ruby specification
      attr_accessor :revision

      # The name of the project
      attr_accessor :name

      # The version of the project
      attr_accessor :version

      # The nick name for the particular version, e.g. "Lucid Lynx".
      attr_accessor :codename

      # The project title
      attr_accessor :title

      # The project summary
      attr_accessor :summary

      # The project description
      attr_accessor :description

      # The licenses of the project
      attr_accessor :licenses

      # The authors of the project
      attr_accessor :authors

      # The current maintainers of the project
      # The first maintainer should be the primary contact.
      attr_accessor :maintainers

      # The resource locators for the project
      attr_accessor :resources

      # The repository URLs for the project
      attr_accessor :repositories

      # The build date of the .ruby file
      attr_accessor :date

      # The directories to search within the project when requiring files
      attr_accessor :load_path  # :loadpath or :require_paths ?

      # The names of the executable scripts
      # NOTE: Do not need, executable should alwasy by in bin/, right?
      #attr_accessor :executables

      # The packages this package requires to function.
      attr_accessor :requirements

      # A list of packages that provide more or less the same functionality.
      # A good example is for a markdown library.
      #
      #   alternatives:
      #     - rdiscount
      #     - redcarpet
      #     - BlueCloth
      #
      attr_accessor :alternatives

      # The packages that this package can replace (near equivalent APIs).
      # This is similar to `alternatives` but defines a stringer relationship.
      # Think Erubis for ERB, or libXML2 or libXML.
      attr_accessor :replacements

      # The packages with which this project cannot function.
      attr_accessor :conflicts

      # 
      # NOTE: This is a Debian concept. Is it useful?
      #attr_accessor :provides

      # The version of Ruby required by the project
      # NOTE: is it possible to to makes this a part of ordinary requirements?
      #attr_accessor :required_ruby_version

      # The post-installation message
      # NOTE: Do we really need such a long name?
      attr_accessor :message #:post_install_message

      # The date the project was started.
      attr_accessor :created

      # The organization by which the project is being developed.
      attr_accessor :organization

      # The company by which the project is being developed.
      #
      # @todo Do we need both company and ogranziation?
      attr_accessor :company

      # Copyright notice for the project.
      attr_accessor :copyright

      # Any user-defined extraneous metadata.
      attr_accessor :extra

# TODO: NOT SURE AT ALL ABOUT THESE

      # The SCM which the project is currently utilizing.
      # NOTE: Is this a good idea?
      attr_accessor :scm

      # The toplevel namespace of API, e.g. `module Foo` or `class Bar`.
      # NOTE: how to best handle this?
      attr_accessor :namespace

      # The engines and versions of ruby the project has been tested under.
      #attr_accessor :engine_check ?

      # The files of the project
      # Is this neccessary?
      #attr_accessor :files

    end

  end

end
