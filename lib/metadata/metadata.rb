# Primary interface.
#
module Metadata

  #
  # File name of `.meta` file. It is obviously `.meta` ;)
  #
  FILE_NAME = '.meta'

  #
  # Current revision of specification.
  #
  CURRENT_REVISION = 0

  #
  # Hash which auto-loads Metaspec Versions.
  #
  # @return [Hash{Integer => Module}]
  #   The Hash of Metaspec revisions and their modules.
  #
  # TODO: Or a capitalized method?
  V = Hash.new do |hash,key|
    revision = key.to_i
    require "metaspec/v#{revision}"

    module_name = "V#{revision}"

    unless const_defined?(module_name)
      raise("unsupported ruby metaspec version: #{revision.inspect}")
    end

    hash[key] = const_get(module_name)
  end

  #
  # Revision factory return a versioned instance of Specification.
  #
  # @param [Hash] data
  #   The metadata to populate the instance.
  #
  def self.new(data)
    revision = data['revision'] || data[:revision]
    unless revision
      # TODO: raise error instead ?
      revison          = CURRENT_REVISION
      data['revision'] = CURRENT_REVISION
    end
    V[revision]::Metadata.new(data)
  end

  #
  #
  #
  def self.load(path=Dir.pwd)
    if File.file?(path)
      read(path)
    else
      find(path)
    end
  end

  #
  # Find project root and read `.meta` file.
  #
  # @param [String] from
  #   The directory from which to start the upward search.
  #
  def self.find(from=Dir.pwd)
    file = File.join(root(from),FILE_NAME)
    read(file)
  end

  #
  # Read `.meta` from file.
  #
  # @param [String] file
  #   The file name from which to read the YAML metadata.
  #
  def self.read(file)
    data = YAML.load_file(file)

    revision = data['revision'] || data[:revision]
    unless revision
      # TODO: raise error instead ?
      revison          = CURRENT_REVISION
      data['revision'] = CURRENT_REVISION
    end

    V[revision]::Data.valid(data)
  end

  #
  # Find project root by looking upward for a `.meta` file.
  #
  # @param [String] from
  #   The directory from which to start the upward search.
  #
  # @return [String]
  #   The path to the `.meta` file.
  #
  # @raise []
  #   The `.meta` file could not be located.
  #
  def self.root(from=Dir.pwd)
    if not path = exists?(from)
      raise Error.exception("could not locate the #{FILE_NAME} file", Errno::ENOENT)
    end
    path
  end

  #
  # Does a .meta file exist?
  #
  # @return [true,false] Whether .meta file exists.
  #
  def self.exists?(from=Dir.pwd)
    path = File.expand_path(from)
    while path != '/'
      if File.file?(File.join(path,FILE_NAME))
        return path
      else
        path = File.dirname(path)
      end
      false #raise Error.exception(".meta file not found", Errno::ENOENT)
    end
    false #raise Error.exception("could not locate the #{FILE_NAME} file", Errno::ENOENT)
  end

  #
  # Alias for exists?
  #
  def self.exist?(from=Dir.pwd)
    exists?(from)
  end

end



require_relative 'base'
require_relative 'validator'

  # Read `.meta` from file.
  #
  # @param [String] file
  #   The file name from which to read the YAML metadata.
  #
  def self.read(file)
    data = YAML.load_file(file)
    #revision = data['revision'] || data[:revision]
    #unless revision
    #  # TODO: raise error instead ?
    #  #revison         = CURRENT_REVISION
    #  data['revision'] = CURRENT_REVISION
    #end
    valid_data = Validator.new(data).to_h
    new(valid_data)
  end

  # Find project root and read `.meta` file.
  #
  # @param [String] from
  #   The directory from which to start the upward search.
  #
  def self.find(from=Dir.pwd)
    file = File.join(root(from),FILE_NAME)
    read(file)
  end

  # Unlike #read, the #load method does not hold the
  # input data to the strict canonical spec.
  #
  # @param [String] file
  #   The file name from which to read the YAML metadata.
  #
  def self.load(file)
    data = YAML.load_file(file)
    #revision = data['revision'] || data[:revision]
    #unless revision
    #  # TODO: raise error instead ?
    #  revison          = CURRENT_REVISION
    #  data['revision'] = CURRENT_REVISION
    #end
    new(data)
  end

  ## Create a revisioned instance of Spec.
  ##
  ## @param [Hash] data
  ##   The metadata to populate the instance.
  ##
  #def initialize(data={})
  #  revision = data['revision'] || data[:revision]
  #
  #  unless revision
  #    revison          = CURRENT_REVISION
  #    data['revision'] = CURRENT_REVISION
  #  end
  #
  #  extend V[revision]::Conventional
  #
  #  super(data)
  #end

