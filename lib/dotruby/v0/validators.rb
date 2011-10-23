if RUBY_VERSION > '1.9'
  require_relative 'attributes'
else
  require 'dotruby/v0/attributes'
end

module DotRuby

  module V0

    # The Validators module is used be the Validator class to model the strict
    # *canonical* specification of the `.ruby` file format. It is a one-to-one
    # mapping with no method aliases or other conveniences.
    #
    module Validators

      include Attributes

      # -- IO Methods ------------------------------------------------------
   
      # By saving via the Validator, we help ensure only the canoncial
      # form even makes it to disk.
      #
      def save!(file)
        File.open(file, 'w') do |f|
          f << to_h.to_yaml
        end
      end

      # -- Writers ------------------------------------------------------------

      # Project's _packaging name_ must be a string without spaces
      # using only `[a-zA-Z0-9_-]`.
      def name=(value)
        Valid.name!(value, :name)
        super(value)
      end

      #
      def version=(value)
        validate(value, :version, :version_string!)
        super(value)
      end

      # Date must be a UTC formated string, time is optional.
      def date=(value)
        Valid.utc_date!(value, :date)
        super(value)
      end

      # Title of package must be a single-line string.
      def title=(value)
        Valid.oneline!(value, :title)
        super(value)
      end

      # Summary must be a single-line string.
      def summary=(value)
        Valid.oneline!(value, :summary)
        super(value)
      end

      # Description must be string.
      def description=(value)
        Valid.string!(value, :description)
        super(value)
      end

      # Codename must a single-line string.
      def codename=(value)
        Valid.oneline!(value, :codename)
        super(value)
      end

      # Loadpath must be an Array of valid pathnames or a String of pathnames
      # separated by colons or semi-colons.
      def load_path=(value)
        Valid.array!(value, :load_path)
        value.each_with_index{ |path, i| Valid.path!(path, "load_path #{i}") }
        super(value)
      end

      # List of language engine/version family supported.
      def engines=(value)
        Valid.array!(value)
        super(value)
      end

      # List of platforms supported.
      def platforms=(value)
        Valid.array!(value)
        super(value)          
      end

      # Requirements must be a list of package references.
      def requirements=(value)
        Valid.array!(value, :requirements)
        value.each_with_index do |r, i|
          Valid.hash!(r, "requirements #{i}")
        end
        super(value)
      end

      # Dependencies must be a list of package references.
      def dependencies=(value)
        Valid.array!(value, :dependencies)
        value.each_with_index do |r, i|
          Valid.hash!(r, "dependencies #{i}")
        end
        super(value)
      end

      # List of packages with which this project cannot function.
      def conflicts=(value)
        Valid.array!(value, :conflicts)
        value.each_with_index do |c, i|
          Valid.hash!(c, "conflicts #{i}")
        end
        super(value)
      end

      #
      def alternatives=(value)
        Valid.array!(value, :alternatives)
        super(value)
      end

      # List of packages for which this package serves as a replacement.
      def replacements=(value)
        Valid.array!(value, :replacements)
        super(value)
      end

      # provides?

      # Suite must be a single line string.
      def suite=(value)
        Valid.oneline!(value, :suite)
        super(value)
      end

# TODO: Company or Organization or both?

      # Company must be a single line string.
      def company=(value)
        Valid.oneline!(value, :company)
        super(value)
      end

# TODO: Maybe organization should be a hash with `name` and `url`?

      # Organization must be a single line string.
      def organization=(value)
        Valid.oneline!(value, :organization)
        super(value)
      end     

      # The creation date must be a valide UTC formatted date.
      def created=(value)
        Valid.utc_date!(value, :created)
        super(value)
      end

# TODO: plural or no?

      # Set sequence of copyrights mappings.
      def copyrights=(value)
        Valid.array!(value, :copyrights)
        value.each{ |h| Valid.hash!(h, :copyrights) }
        super(value)
      end

      # Authors must an array of hashes in the form
      # of `{name: ..., email: ..., :website ..., roles: [...] }`.
      def authors=(value)
        Valid.array!(value, :authors)
        value.each{ |h| Valid.hash!(h, :authors) }
        super(value)
      end

      # Resources  must be a mapping of <code>name => URL</code>.
      def resources=(value)
        Valid.hash!(value, :resources)
        value.each do |id, url|
          Valid.url!(url, "resources #{id}")
        end
        super(value)
      end

      # Repositores must be a mapping of <code>name => URL</code>.
      def repositories=(value)
        Valid.array! value, :repositories
        value.each_with_index do |data, index|
          Valid.hash! data, "repositories #{index}"
          #Valid.uri!  data['uri'], "repositories ##{index}"
          Valid.oneline! data['uri'], "repositories ##{index}"
          Valid.oneline! data['id'],  "repositories ##{index}" if data['id']
          Valid.word!    data['scm'], "repositories ##{index}" if data['scm']
        end
        super value
      end

      # The post-installation message must be a String.
      def install_message=(value)
        Valid.string!(value)
        super(value)
      end

# TODO: How to handle project toplevel namespace?

      # Namespace must be a single line string.
      def namespace=(value)
        Valid.oneline!(value, :namespace)
        #raise ValidationError unless /^(class|module)/ =~ value
        super(value)
      end

# TODO: SCM ?

      # SCM must be a word.
      def scm=(value)
        Valid.word!(value, :scm)
        super(value)
      end

      #
      def extra=(value)
        Valid.hash!(value, :extra)
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

      #def validate_package_references(field, references)
      #  unless Array === references
      #    raise(ValidationError, "#{field} must be a hash")
      #  end
      #  # TODO: valid version and type
      #end

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
