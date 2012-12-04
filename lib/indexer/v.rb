module Indexer

  #
  # Hash which auto-loads specification revsions.
  #
  # @return [Hash{Integer => Module}]
  #   The Hash of revisions and their modules.
  #
  # TODO: Or a capitalized method?
  #
  V = Hash.new do |hash,key|
    revision = key || REVISION

    begin
      require "indexer/v#{revision}"
    rescue LoadError
      raise Error.exception("unsupported revision: #{revision.inspect}")
    end

    module_name = "V#{revision}"

    unless Indexer.const_defined?(module_name)
      Error.exception("unsupported revision: #{revision.inspect}")
    end

    hash[key] = Indexer.const_get(module_name)
  end

end
