module RBits
  class Unsigned < Type
    def initialize(size, options = {})
      @size = size
      @default_value = options[:default] || 0
      @constant = options[:const]
    end
  
    def write(io, value)
      current_value = value_to_write(value)
      target = current_value.to_bytes(@size)
      io.write_bytes(target)
    end
  
    def read(io)
      source_from_io = io.read_bytes(@size)
      current_value = source_from_io.to_unsigned
      raise "expected constant #{@constant} but #{current_value}" if valid_read_value?(current_value)
      current_value
    end
  
    private
    def valid_read_value?(value)
      @constant && @constant != value
    end
  
    def value_to_write(value)
      @constant || value || @default_value
    end
  end

  [1, 2, 4, 8].each do |size|
    eval <<-EOMETHODEF
    class U#{size} < Unsigned
      field_type :u#{size}

      def initialize(options)
        super(#{size}, options)
      end
    end
    EOMETHODEF
  end
end