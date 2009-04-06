module RBits
  class String < Array
    class << self
      attr_reader :read_size_proc, :write_size_proc, 
        :size_descriptor, :value_descriptor
    
      def values options
        @value_descriptor = Type.create_field(options[:type])
      end
    
      def size options
        @size_descriptor = Type.create_field(options[:type])
        @read_size_proc = options[:read_proc]
        @write_size_proc = options[:write_proc]
      end
    
      def value_descriptor
        @value_descriptor ||= Type.create_field(:u1)
      end
    
      def size_descriptor
        @size_descriptor ||= Type.create_field(:u1)
      end
    
      def read_size_proc
        @read_size_proc ||= lambda{|size| size}
      end
    
      def write_size_proc
        @write_size_proc ||= lambda{|size| size}
      end
    end
  
    def read(io)
      array = super(io)
      array.pack("c#{array.size}")
    end
  
    def write(io, text)
      super(io, text.unpack("c#{text.size}"))
    end
  end
end