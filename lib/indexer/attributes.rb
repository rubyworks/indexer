module Indexer

  # Tracks supported attributes.
  def self.attributes
    @attributes ||= []
  end

  # The Attributes module defines all of the accepted metadata fields.
  module Attributes

    # Define attribute, plus track it.
    def self.attr_accessor(name)
      Indexer.attributes << name.to_sym

      class_eval %{
        def #{name}
          @data[:#{name}]
        end
        def #{name}=(val)
          @data[:#{name}] = val
        end
      }
    end

    #
    def attributes
      Indexer.attributes
    end

    # The revision of ruby meta specification.
    attr_accessor :revision

    #def revision
    #  REVISION
    #end

    # The type of ruby meta specification.
    attr_accessor :type

    # Files from which to import metadata.
    attr_accessor :sources

    # The name of the project
    attr_accessor :name

    # The version of the project
    attr_accessor :version

    # The nick name for the particular version, e.g. "Lucid Lynx".
    attr_accessor :codename

    # The date of this version.
    attr_accessor :date

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

    # The organizations involved with the project.
    attr_accessor :organizations

    # The resource locators for the project.
    attr_accessor :resources

    # The repository URLs for the project.
    attr_accessor :repositories

    # TODO: Might webcvs simply be taken from a repository?
    #       Or perhaps from a specifically labeled resource?

    # URI for linking to source code.
    attr_accessor :webcvs

    # Map of path sets which can be used to identify paths within the project.
    # The actual path keys largely depend on the project type, but in general
    # should reflect the FHS,
    #
    # For example, the `lib` path key is used by Ruby projects to designate
    # which project paths to search within when requiring files.
    attr_accessor :paths

    # List of language engine/version family supported.
    attr_accessor :engines

    # List of platforms supported.
    attr_accessor :platforms

    # The names of the executable scripts
    # NOTE: Do not need, executable should alwasy by in bin/, right?
    #attr_accessor :executables

    # The packages this package requires to function.
    attr_accessor :requirements  #:dependencies

    # A list of packages that provide more or less the same functionality.
    # A good example is for a markdown library.
    #
    #   alternatives:
    #     - rdiscount
    #     - redcarpet
    #     - BlueCloth
    #
    attr_accessor :alternatives

    # The packages with which this project cannot function.
    attr_accessor :conflicts

    # 
    # NOTE: This is a Debian concept. Is it useful?
    #attr_accessor :provides

    # Categories can be used to help clarify the purpose of
    # a project, e.g. `testing` or `rest`. There are no standard
    # categories, just use common sense. Categories must be single-line
    # strings. When comparisons are made they will be downcased.
    attr_accessor :categories

    # The version of Ruby required by the project
    # NOTE: is it possible to to makes this a part of ordinary requirements?
    #attr_accessor :required_ruby_version

    # The post-installation message.
    attr_accessor :install_message

    # The date the project was started.
    attr_accessor :created

    # The toplevel namespace of API, e.g. `module Foo` or `class Bar`.
    # NOTE: how to best handle this?
    attr_accessor :namespace

    # The names of any user-defined fields.
    attr_accessor :customs

  protected

    #
    # Initializes the {Metadata} attributes.
    #
    # @todo Is it okay to default type to `ruby`?
    #
    def initialize_attributes
      @data = {
        :revision      => REVISION,
        :type          => 'ruby',
        :sources       => [],
        :authors       => [],
        :organizations => [],
        :copyrights    => [],
        :alternatives  => [],
        :requirements  => [],
        :conflicts     => [],
        :repositories  => [],
        :resources     => [],
        :categories    => [],
        :customs       => [],
        :paths         => {'lib' => ['lib']}
      }
    end

  end

end
