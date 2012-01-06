module DotRuby

  # First revision of dotruby specification.
  module V0

    # Tracks supported attributes.
    def self.attributes
      @attributes ||= []
    end

    # The Attributes module defines all of the accepted metadata fields.
    module Attributes

      # Define attribute, plus track it.
      def self.attr_accessor(name)
        V0.attributes << name.to_sym

        class_eval %{
          def #{name}
            @data['#{name}']
          end
          def #{name}=(val)
            @data['#{name}'] = val
          end
        }
      end

      #
      def attributes
        V0.attributes
      end

      # The revision of .ruby specification.
      def revision ; 0 ; end

      # Internal sources for building .ruby file.
      attr_accessor :source

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

      # The suite to which the project belongs.
      attr_accessor :suite

      # The copyrights and licenses of the project.
      attr_accessor :copyrights

      # The authors of the project
      # The first author should be the primary contact.
      attr_accessor :authors

      # The resource locators for the project.
      attr_accessor :resources

      # TODO: Give some thought to #repositories and #scm_uri, might they be unified somehow?

      # The repository URLs for the project
      attr_accessor :repositories

      # URI for linking to source code.
      attr_accessor :scm_uri

      # The build date of the .ruby file
      attr_accessor :date

      # The directories to search within the project when requiring files
      attr_accessor :load_path  # :loadpath or :require_paths ?

      # List of language engine/version family supported.
      attr_accessor :engines

      # List of platforms supported.
      attr_accessor :platforms

      # The names of the executable scripts
      # NOTE: Do not need, executable should alwasy by in bin/, right?
      #attr_accessor :executables

      # The packages this package requires to function.
      attr_accessor :requirements

      # The system pacakges this package needs to function.
      attr_accessor :dependencies

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

      # The post-installation message.
      attr_accessor :install_message

      # The date the project was started.
      attr_accessor :created

      # The company by which the project is being developed.
      #attr_accessor :company

      # The organization under which the project is being developed.
      attr_accessor :organization

      # The toplevel namespace of API, e.g. `module Foo` or `class Bar`.
      # NOTE: how to best handle this?
      attr_accessor :namespace

      # Any user-defined extraneous metadata.
      attr_accessor :extra

    protected

      #
      # Initializes the {Metadata} attributes.
      #
      def initialize_attributes
        @data = {
          'source'       => [],
          'authors'      => [],
          'copyrights'   => [],
          'replacements' => [],
          'alternatives' => [],
          'requirements' => [],
          'dependencies' => [],
          'conflicts'    => [],
          'repositories' => [],
          'resources'    => {},
          'extra'        => {},
          'load_path'    => ['lib']
        }
      end

    end

  end

end
