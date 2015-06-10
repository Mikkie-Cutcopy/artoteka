module Chain

  class ChainObject

    attr_reader :circle

    def initialize(array = [], hash_options = {})
      @chain_array = array
      @chain = @chain_array.map {|content| Link.new(content) }
      @chain = @chain.each_with_index.map do |link, index|
        link.index = index
        link.previous = @chain[index - 1]
        link.next = @chain[index + 1]
        link
      end
        hash_options[:circle].eql?(true) ? self.circle = true : self.circle = false
       self.set_to!(hash_options[:set_to]) if hash_options[:set_to]
       @current_link ||= @chain.first
    end

    def circle=(bool)
      if bool.is_a?(TrueClass) || bool.is_a?(FalseClass)
        @circle = bool
        case bool
          when true
            @chain.last.next = @chain.first
            @chain.first.previous = @chain.last
          when false
            @chain.last.next = nil
            @chain.first.previous = nil
        end
        bool
      else
        raise ArgumentError, "The argument should be boolean"
      end

    end

    def next!
      if @current_link.next
        @current_link = @current_link.next
        @current_link.content
      end
    end

    def next
      @current_link.next.try(:content)
    end

    def previous!
      if @current_link.previous
        @current_link = @current_link.previous
        @current_link.content
      end
    end

    def previous
      @current_link.previous.try(:content)
    end

    def to_start!
      @current_link = @chain.first
      @current_link.content
    end

    def first
      @chain_array.first
    end

    def last
      @chain_array.last
    end

    def to_end!
      @current_link = @chain.last
      @current_link.content
    end

    def current
      @current_link.content
    end

    def set_to!(n)
      if n.is_a?(Fixnum)
        @current_link = @chain.rotate(n).first
        @current_link.content

      end
    end

    def [](n)
      if n.is_a?(Fixnum)
        @chain.rotate(n).first.content
      end
    end

    def +(chain)
      if chain.is_a?(Chain::ChainObject)
        Chain::ChainObject.new(self.to_a + chain.to_a)
      else
        raise ArgumentError, "The argument must be Chain::ChainObject"
      end
    end

    def to_a(hash_options = nil)
      if hash_options.is_a?(Hash) && hash_options[:from]

        if hash_options[:from].is_a?(Symbol)

        case hash_options[:from]
        when :current
          @chain.rotate(@current_link.index).map(&:content)
        when :next
          @chain.rotate(@current_link.next.index).map(&:content)
        when :previous
          @chain.rotate(@current_link.previous.index).map(&:content)
        else
          @chain_array
        end

        elsif hash_options[:from].is_a?(Fixnum)
          @chain_array.rotate(hash_options[:from])

        else
          raise ArgumentError, "Forbidden type for option :from"
        end
      else
        @chain_array
      end

    end
  end

  Link = Struct.new(:content, :previous, :next, :index)

end