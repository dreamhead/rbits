module RBits
  class Array < Type
    class << self
      attr_reader :read_size_proc, :write_size_proc, 
        :size_descriptor, :value_descriptor
    
      def values options
        @value_descriptor = Type.create_field(options[:type])
      end
    
      def size options
        @size_descriptor = Type.create_field(options[:type])
        @read_size_proc = options[:read_proc] || lambda {|size| size }
        @write_size_proc = options[:write_proc] || lambda {|size| size }
      end
    end
  
    def initialize(options = {})
    end
  
    def write(io, array)
      write_size(array.size, io)
      write_array(array, io)
    end
  
    def read(io)
      size = read_size(io)
      read_array(size, io)
    end
  
    private
    def actual_write_size size
      self.class.write_size_proc.call(size)
    end
  
    def actual_read_size size
      self.class.read_size_proc.call(size)
    end

    def read_size(io)
      size_from_io = self.class.size_descriptor.read(io)
      actual_read_size(size_from_io)
    end

    def write_size(size, io)
      size_to_io = actual_write_size(size)
      self.class.size_descriptor.write(io, size_to_io)
    end

    def read_array(size, io)
      array = []
      desc = self.class.value_descriptor

      size.each do
        array << desc.read(io)
      end
      
      array
    end

    def write_array(array, io)
      array.each do |value|
        self.class.value_descriptor.write(io, value)
      end
    end
  end
end