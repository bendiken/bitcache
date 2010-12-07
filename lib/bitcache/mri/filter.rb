module Bitcache
  ##
  # A Bloom filter for Bitcache identifiers.
  #
  # @see http://en.wikipedia.org/wiki/Bloom_filter
  class Filter < Struct
    DEFAULT_CAPACITY = 1024 # elements
    BITS_PER_ELEMENT = 8    # bits

    ##
    # Initializes a new filter from the given `bitmap`.
    #
    # @example Constructing a new filter
    #   Filter.new
    #
    # @param  [String, Integer] bitmap
    #   the initial bitmap for the filter
    # @yield  [filter]
    # @yieldparam  [Filter] `self`
    # @yieldreturn [void] ignored
    def initialize(bitmap = nil, &block)
      @bitmap = case bitmap
        when nil     then "\0" * DEFAULT_CAPACITY
        when Integer then "\0" * bitmap
        when String  then bitmap.dup
        else raise ArgumentError, "expected a String or Integer, but got #{bitmap.inspect}"
      end
      @bitmap.force_encoding(Encoding::BINARY) if @bitmap.respond_to?(:force_encoding) # for Ruby 1.9+

      if block_given?
        case block.arity
          when 0 then instance_eval(&block)
          else block.call(self)
        end
      end
    end

    ##
    # Initializes a filter cloned from `original`.
    #
    # @param  [Filter] original
    # @return [void]
    def initialize_copy(original)
      @bitmap = original.instance_variable_get(:@bitmap).clone
    end

    ##
    # Prevents further modifications to this filter.
    #
    # @return [void] `self`
    def freeze
      bitmap.freeze
      super
    end

    ##
    # @private
    attr_reader :bitmap

    ##
    # Returns `true` if no elements have been inserted into this filter.
    #
    # @return [Boolean] `true` or `false`
    def empty?
      /\A\x00+\z/ === bitmap
    end
    alias_method :zero?, :empty?

    ##
    # Returns the bit at the given `index`.
    #
    # @example Checking the state of a given bit
    #   filter[42]          #=> true or false
    #
    # @param  [Integer, #to_i] index
    #   a bit offset
    # @return [Boolean] `true` or `false`; `nil` if `index` is out of bounds
    def [](index)
      q, r = index.to_i.divmod(8)
      byte = bitmap[q]
      byte ? !((byte.ord & (1 << r)).zero?) : nil
    end

    ##
    # Updates the bit at the given `index` to `value`.
    #
    # @example Toggling the state of a given bit
    #   filter[42] = true   # sets the bit at position 42
    #   filter[42] = false  # clears the bit at position 42
    #
    # @param  [Integer] index
    #   a bit offset
    # @param  [Boolean] value
    #   `true` or `false`
    # @return [Boolean] `value`
    # @raise  [IndexError] if `index` is out of bounds
    # @raise  [TypeError] if the filter is frozen
    def []=(index, value)
      q, r = index.to_i.divmod(8)
      byte = bitmap[q]
      raise IndexError, "index #{index} is out of bounds" unless byte
      raise TypeError, "can't modify frozen filter" if frozen?
      bitmap[q] = value ?
        (byte.ord | (1 << r)).chr :
        (byte.ord & (0xff ^ (1 << r))).chr
    end

    # Load optimized method implementations when available:
    send(:include, Bitcache::FFI::Filter) if defined?(Bitcache::FFI::Filter)
  end # Filter
end # Bitcache
