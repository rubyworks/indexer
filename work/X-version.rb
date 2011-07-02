module POM

  module Version

    # TODO: This classes rich functionality needs to be incorporated
    # into the Number and Constraint classes as needed.

    # VersionNumber class models a dot-separated sequence
    # of numbers or strings according to the most common
    # rational versioning practices in the Ruby community.
    #
    # Version numbers consist of major, minor and patch
    # segements along with an optional build segement which
    # can itself be seperated into a state and revision count.
    #
    # The VersionNumber class is immutable. All methods that
    # manipulate the verison return a new VersioNumber object.
    #
    class VersionNumber
      include Enumerable
      include Comparable

      # Recognized build states in order of "completion".
      STATES = ['alpha', 'beta', 'pre', 'rc']

      # Recognized version slots.
      SLOTS = %w{major minor patch state build revision}

      # Shortcut for creating a new verison number
      # given segmented elements.
      #
      #   VersionNumber[1,0,0].to_s
      #   #=> "1.0.0"
      #
      #   VersionNumber[1,0,0,:pre,2].to_s
      #   #=> "1.0.0.pre.2"
      #
      def self.[](*args)
        new(args)
      end

      #
      def self.parse_string(version_string)
        new version_string.split('.').map do |s|
          /^\d+$/ =~ s ? s.to_i : s.to_s 
        end
      end

      # Create a new VersionNumber.
      #
      # version - a String, Hash or Array repsenting the version number
      #
      #   VersionNumber.new("1.0.0")
      #   VersionNumber.new([1,0,0])
      #   VersionNumber.new(:major=>1,:minor=>0,:patch=>0)
      #
      # Returns a new VersionNumber object.
      def initialize(version)
        case version
        when String
          version = version.split('.')
          @segments = version.map{ |s| /\d+/ =~ s ? s.to_i : s.to_s }
        when Hash
          version - version.inject({}){|h,(k,v)| h[k.to_sym] = v; h}
          version = version.values_at(:major, :minor, :patch, :state, :build).compact
          @segments = version.split('.').map{ |s| /\d+/ =~ s ? s.to_i : s.to_s }
        when Array
          version = version.join('.')
          @segments = version.split('.').map{ |s| /\d+/ =~ s ? s.to_i : s.to_s }
        when VersionNumber
          @segments = version.segments
        else
          version = version.to_s.split('.')
          @segments = version.map{ |s| /\d+/ =~ s ? s.to_i : s.to_s }
        end
      end

      #
      def to_a
        @segments.dup
      end

      # Convert version to a dot-separated string.
      #
      #   VersionNumber[1,2,0].to_s
      #   #=> "1.2.0"
      #
      def to_s
        @segments.join('.')
      end

      # This method is the same as #to_s. It is here becuase
      # `File.join` calls it instead of #to_s.
      #
      #   VersionNumber[1,2,0].to_str
      #   #=> "1.2.0"
      #
      def to_str
        @segments.join('.')
      end

      # Returns a String detaling the version number.
      # Essentially it is the same as #to_s.
      #
      #   VersionNumber[1,2,0].inspect
      #   #=> "1.2.0"
      #
      def inspect
        to_s
      end

      # Fetch a sepecific segement by index number.
      # In no value is found at that position than
      # zero (0) is returned instead.
      #
      #   v = VersionNumber[1,2,0]
      #   v[0]  #=> 1
      #   v[1]  #=> 2
      #   v[3]  #=> 0
      #   v[4]  #=> 0
      #
      # Zero is returned instead of +nil+ to make different
      # version numbers easier to compare.
      def [](index)
        @segments.fetch(index,0)
      end

      # "Spaceship" comparsion operator.
      #
      # FIXME: Ensure it can handle state.
      def <=>( other )
        #other = other.to_t
        [@segments.size, other.size].max.times do |i|
          if String === @segments[i] && String == other[i]
            c = @segments[i] <=> other[i]
          elsif String === @segments[i]
            c = 1
          elsif String === other[i]
            c = -1
          else
            c = (@segments[i] || 0) <=> (other[i] || 0)
          end
          return c if c != 0
        end
        0
      end

      # For pessimistic constraint (like '~>' in gems).
      #
      # FIXME: Ensure it can handle trailing state.
      def =~(other)
        upver = other.bump(:last)
        #@segments >= other and @segments < upver
        self >= other and self < upver
      end

      # Major is the first number in the version series.
      #
      #   VersionNumber[1,2,0].major
      #   #=> 1
      #
      def major
        @segments[0] || 0
      end

      # Minor is the second number in the version series.
      #
      #   VersionNumber[1,2,0].minor
      #   #=> 2
      #
      def minor
        @segments[1] || 0
      end

      # Patch is third number in the version series.
      #
      #   VersionNumber[1,5,3].patch
      #   #=> 3
      #
      def patch
        @segments[2] || 0
      end

      # The build number is everything from state segment onward.
      # If no state entries exists then +nil+ is returned.
      #
      #   VersionNumber[1,2,0,:pre,6].build
      #   #=> 'pre.6'
      #
      #   VersionNumber[1,2,0].build
      #   #=> nil
      #
      def build
        if i = state_index
          b = @segments[i..-1].join('.')
        else
          b = @segments[3..-1].join('.')
        end
        b.empty? ? nil : b
      end

      # State is the version segment that matches any entry
      # in the STATES constant. These include +pre+, +beta+, +alpha+,
      # and so on.
      #
      #   VersionNumber[1,2,0,:pre,6].state
      #   #=> 'pre'
      #
      def state
        if i = state_index
          @segments[i]
        else
          nil
        end
      end

      # TODO: Is this the same as #state?
      def status
        if md = /(\w+)/.match(build.to_s)
          md[1].to_sym
        end
      end

      # Return the state revision count. This is the
      # number that occurs after the state.
      #
      #   VersionNumber[1,2,0,:rc,4].revision
      #   #=> 4
      #
      def revision
        if i = state_index
          @segments[i+1] || 0
        else
          nil
        end
      end

      # Bump the version returning a new version number object.
      # Select +which+ segement to bump by name: +major+, +minor+,
      # +patch+, +state+, +build+ and also +last+.
      #
      #   VersionNumber[1,2,0].bump(:patch).to_s
      #   #=> "1.2.1"
      #
      #   VersionNumber[1,2,1].bump(:minor).to_s
      #   #=> "1.3.0"
      #
      #   VersionNumber[1,3,0].bump(:major).to_s
      #   #=> "2.0.0"
      #
      #   VersionNumber[1,3,0,:pre,1].bump(:build).to_s
      #   #=> "1.3.0.pre.2"
      #
      #   VersionNumber[1,3,0,:pre,2].bump(:state).to_s
      #   #=> "1.3.0.rc.1"
      #
      def bump(which=:patch)
        case which.to_sym
        when :major, :first
          v = [inc(major), 0, 0]
        when :minor
          v = [major, inc(minor), 0]
        when :patch
          v = [major, minor, inc(patch)]
        when :state
          if i = state_index
            if n = inc(@segments[i])
              v = @segments[0...i] + [n] + (@segments[i+1] ? [1] : [])
            else
              v = @segments[0...i]
            end
          else
            v = @segments.dup
          end
        when :build
          if i = state_index
            if i == @segments.size - 1
              v = @segments + [1]
            else
              v = @segments[0...-1] + [inc(@segments.last)]
            end
          else
            if @segments.size <= 3
              v = @segments + [1]
            else
              v = @segments[0...-1] + [inc(@segments.last)]
            end
          end
        when :revision
          if i = state_index
            v = @segments[0...-1] + [inc(@segments.last)]
          else
            v = @segments[0..2] + ['alpha', 1]
          end
        when :last
          v = @segments[0...-1] + [inc(@segments.last)]
        else
          v = @segments.dup
        end
        self.class.new(v.compact)
      end

      # Return a new version have the same major, minor and
      # patch levels, but with a new state and revision count.
      #
      #   VersionNumber[1,2,3].restate(:pre,2).to_s
      #   #=> "1.2.3.pre.2"
      #
      #   VersionNumber[1,2,3,:pre,2].restate(:rc,4).to_s
      #   #=> "1.2.3.rc.4"
      #
      def restate(state, revision=1)
        if i = state_index
          v = @segments[0...i] + [state.to_s] + [revision]
        else
          v = @segments[0...3] + [state.to_s] + [revision]
        end
        self.class.new(v)
      end

      # Iterate of each segment of the version. This allows
      # all enumerable methods to be used.
      #
      #   VersionNumber[1,2,3].map{|i| i + 1}
      #   #=> [2,3,4]
      #
      # Though keep in mind that the state segment is not
      # a number (and techincally any segment can be a string
      # instead of an integer).
      def each(&block)
        @segments.each(&block)
      end

      # Return the number of version segements.
      #
      #   VersionNumber[1,2,3].size
      #   #=> 3
      #
      def size
        @segments.size
      end

      # Does this version match a given constraint? The constraint is a String
      # in the form of "{operator} {version number}". Multiple constraints
      # can be given in the same string by separating them with a comma or 
      # semi-colon.
      def match?(constraint)
        cons = constraint.split(/[,;]/)
        cons.all? do |con|
          self.class.constraint_lambda(con).call(self)
        end
      end

      ;; private

      # Segement incrementor.
      def inc(val)
        if i = STATES.index(val.to_s)
          STATES[i+1]
        else
          val.succ
        end
      end

      # Return the index of the first recognized state.
      #
      #   VersionNumber[1,2,3,:pre,3].state_index
      #   #=> 3
      #
      # You might as why this is needed, since the state
      # position should alwasy be 3. However, there isn't 
      # always a state entry, which means this method will
      # return +nil+, and we also leave open the potential
      # for extra-long version numbers --though we do not
      # recommend the idea, it is possible.
      def state_index
        @segments.index{ |s| STATES.include?(s) }
      end

      ;; protected

      # Return the undelying segments array.
      attr :segments

      ;; public

      # Parses a string constraint returning the operation as a lambda.
      def self.constraint_lambda(constraint)
        op, val = *parse_constraint(constraint)
        lambda{ |t| t.send(op, val) }
      end

      # Parses a string constraint returning the operator and value.
      def self.parse_constraint(constraint)
        constraint = constraint.strip
        #re = %r{^(=~|~>|<=|>=|==|=|<|>)?\s*(\d+(:?[-.]\d+)*)$}
        re = %r{^(=~|~>|<=|>=|==|=|<|>)?\s*(\d+(:?[-.]\w+)*)$}
        if md = re.match(constraint)
          if op = md[1]
            op = '=~' if op == '~>'
            op = '==' if op == '='
            val = new(md[2].split(/\W+/))
          else
            op = '=='
            val = new(constraint.split(/\W+/))
          end
        else
          raise ArgumentError, "invalid constraint '#{constraint}'"
        end
        return op, val
      end

      # TODO: Could use a class level compare?
      def self.cmp(version1, version2)
      end

    end

  end

end

