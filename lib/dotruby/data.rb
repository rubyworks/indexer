module DotRuby

  # Data class subclasses Base class.
  require 'dotruby/base'

  # The Data class models the strict *canonical* specification of
  # the `.ruby` file format. It is a one-to-one mapping with no method aliases
  # or other conveniences. The class is primarily intended for internal use.
  # Developers will typically use the Spec class, which is designed for
  # convenience.
  #
  class Data < Base

    # Save `.ruby` file.
    #
    # @param [String] file
    #   The file name in which to save the metadata as YAML.
    #
    def save!(file=FILE_NAME)
      File.open(file, 'w') do |f|
        #f << to_h.to_yaml
        to_yaml(f)
      end
    end

    # Read `.ruby` from file.
    #
    # @param [String] file
    #   The file name in which to read the YAML metadata.
    #
    def self.read(file)
      new(YAML.load_file(file))
    end

    # Find project root and read `.ruby` file.
    #
    # @param [String] from
    #   The directory from which to start the upward search.
    #
    def self.find(from=Dir.pwd)
      read(File.join(root(from),FILE_NAME))
    end

  end

end
