module DotRuby

  module V0

    # The Canonical module defines explict setters for {Metadata}'s attributes.
    # These setters follow strict validation rules specific to reading and
    # writing of `.ruby` YAML formatted files.
    module Canonical

      # Canonical module requires Attributes module.
      if RUBY_VERSION > '1.9'
        require_relative 'attributes'
      else
        require 'dotruby/v0/attributes'
      end

      # The Canonical module defines explict setters for {Metadata}'s attributes.
      # These setters follow strict validation rules specific to reading and
      # writing of `.ruby` YAML formatted files.
      #
      # TODO: Should each field get it's own validation method, e.g. validate_name().
      module Validation

        # Canonical uses time library to validate date-time fields.
        require 'time'

        # Regular expression to limit date-time fields to ISO 8601 (Zulu).
        # TODO: support full standard
        RE_DATE_TIME = /^\d\d\d\d-\d\d-\d\d(\s+\d\d:\d\d:\d\d)?$/

        # Project's _packaging name_ must be a string without spaces
        # using only `[a-zA-Z0-9_-]`.
        def name=(value)
          validate_word(:name, value)
          super(value)
        end

        #
        def version=(value)
          validate_string(:version, value)
          case value
          when /^\D/
            raise(InvalidMetadata, "version must start with numer -- #{value}")
          when /[^.A-Za-z0-9]/
            raise(InvalidMetadata, "version contains invalid characters -- #{value}")
          end
          super(value)
        end

        # Date must be a UTC formated string, time is optional.
        def date=(value)
          validate_date(:date, value)
          super(value)
        end

        # Title of package must be a single-line string.
        def title=(value)
          validate_single_line(:title, value)
          super(value)
        end

        # Summary must be a single-line string.
        def summary=(value)
          validate_single_line(:summary, value)
          super(value)
        end

        # Description must be string.
        def description=(value)
          validate_string(:description, value)
          super(value)
        end

        # Codename must a single-line string.
        def codename=(value)
          validate_single_line(:codename, value)
          super(value)
        end

        # Loadpath must be an Array of valid pathnames or a String of pathnames
        # separated by colons or semi-colons.
        def load_path=(value)
          validate_array(:load_path, value)
          super(value)
        end

        # Requirements must be a list of package references.
        def requirements=(value)
          validate_package_references(:requirements, value)
          super(value)
        end

        # List of packages with which this project cannot function.
        def conflicts=(value)
          validate_package_references(:conflicts, value)
          super(value)
        end

        #
        def alternatives=(value)
          validate_array(:alternatives, value)
          super(value)
        end

        # List of packages for which this package serves as a replacement.
        def replacements=(value)
          validate_array(:replacements, value)
          super(value)
        end

        # provides?

        # Suite must be a single line string.
        def suite=(value)
          validate_single_line(:suite, value)
          super(value)
        end

  # TODO: Company or Organization or both?

        # Company must be a single line string.
        def company=(value)
          validate_single_line(:company, value)
          super(value)
        end

        # Organization must be a single line string.
        def organization=(value)
          validate_single_line(:organization, value)
          super(value)
        end     

        # The creation date must be a valide UTC formatted date.
        def created=(value)
          validate_date(:created, value)
          super(value)
        end

        # List of license, e.g. 'Apache 2.0'.
        def licenses=(value)
          validate_array(:licenses, value)
          super(value)
        end

        # Authors must an array of `name <email>` strings or hashes in the
        # form of `{name: ..., email: ..., :website ... }`.
        def authors=(value)
          validate_array(:authors, value)
          super(value)
        end

        # Maintainers must an array of `name <email>` strings or hashes in the
        # form of `{name: ..., email: ..., :website ..., roles: [...] }`.
        def maintainers=(value)
          validate_array(:maintainers, value)
          super(value)
        end

        # Resources  must be a mapping of <code>name => URL</code>.
        def resources=(value)
          validate_hash(:resources, value)
          value.each do |name, url|
            validate_url("resources - #{name}", url)
          end
          super(value)
        end

        # Repositores must be a mapping of <code>name => URL</code>.
        def repositories=(value)
          validate_hash(:repositories, value)
          value.each do |name, url|
            validate_url("repositories - #{name}", url)
          end
          super(value)
        end

        # The post-installation message must be a String.
        def message=(value)
          validate_string(:message, value)
          super(value)
        end

        # Copyright must be a string.
        def copyright=(value)
          validate_string(:copyright, value)
          super(value)
        end

        # Namespace must be a single line string.
        def namespace=(value)
          validate_single_line(:namespace, value)
          #raise InvalidMetadata unless /^(class|module)/ =~ value
          super(value)
        end

        # SCM must be a word.
        def scm=(value)
          validate_word(value)
          super(value)
        end

        #
        def extra=(value)
          validate_hash(:extra, value)
          super(value)
        end

        # A specification is not valid without a name and verison.
        #
        # @return [Boolean] valid specification?
        def valid?
          return false unless name
          return false unless version
          true
        end

      private

        def validate_string(field, string)
          unless String === string
            raise(InvalidMetadata, "#{field} must be a string")
          end
        end

        def validate_single_line(field, string)
          validate_string(field, string)
          if string.index("\n")
            raise(InvalidMetadata, "#{field} must have only one line")
          end
        end

        def validate_word(field, word)
          validate_string(field, word)
          raise(InvalidMetadata, "#{field} must start with letter -- #{word}") if /^[A-Za-z]/ !~ word
          raise(InvalidMetadata, "#{field} must end with a letter or number -- #{word}") if /[A-Za-z0-9]$/ !~ word
          raise(InvalidMetadata, "#{field} must be a world -- #{word}") if /[^A-Za-z0-9_-]/ =~ word
        end

        def validate_array(field, array)
          unless Array === array
            raise(InvalidMetadata, "#{field} must be an array")
          end
        end

        def validate_hash(field, hash)
          unless Hash === hash
            raise(InvalidMetadata, "#{field} must be a Hash")
          end
        end

        def validate_date(field, date)
          validate_string(field, date)
          unless RE_DATE_TIME =~ date
            raise(InvalidMetadata, "#{field} must be a UTC formatted date string")
          end
          begin
            Time.parse(date)
          rescue
            raise(InvalidMetadata, "#{field} must be a UTC formatted date string")
          end
        end
     
        def validate_package_references(field, references)
          unless Hash === references
            raise(InvalidMetadata, "#{field} must be a hash")
          end
          # TODO: valid version and type
        end

        def validate_url(field, url)
          unless /^(\w+)\:\/\/\S+$/ =~ url
            raise(InvalidMetadata, "#{field} must be a URL")
          end
        end

      protected

        #
        # Initializes the {Metadata} attributes.
        #
        def initialize_attributes
          @authors               = []
          @external_requirements = []
          @licenses              = []
          @maintainers           = []
          @replacements          = []

          @conflicts             = {}
          @extra                 = {}
          @repositories          = {}
          @requirements          = {}
          @resources             = {}

          @load_path             = ['lib']

          #@files = []
        end

      end

      include Attributes
      include Validation

    end

  end

end
