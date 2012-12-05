class Hash
  def to_h; self; end unless method_defined?(:to_h)
end

#
def ARGV.clap(argv, opts)
  argv = argv.dup
  args = []

  opts = opts.inject({}) do |h,(k,v)|
    k.to_s.split(/\s+/).each{|o| h[o]=v}; h
  end

  while argv.any?
    item = argv.shift
    flag = opts[item]

    if flag
      # Work around lambda semantics in 1.8.7.
      arity = [flag.arity, 0].max

      # Raise if there are not enough parameters
      # available for the flag.
      if argv.size < arity
        raise ArgumentError
      end

      # Call the lambda with N items from argv,
      # where N is the lambda's arity.
      flag.call(*argv.shift(arity))
    else

      # Collect the items that don't correspond to
      # flags.
      args << item
    end
  end

  args
end

