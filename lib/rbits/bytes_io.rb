module RBits
  class BytesIO
    attr_accessor :bytes
  
    def initialize(bytes = [])
      @bytes = bytes
      @current = 0
    end
  
    def write_bytes(bytes)
      @bytes += bytes
    end
    
    def read_bytes(size)
      raise 'nothing read from source' if (@current + size > @bytes.size)
      @current += size
      @bytes[(@current - size)..(@current - 1)]
    end
  end
  
  class BytesIOWrapper
    def initialize io
      @io = io
    end
    
    def write_bytes(bytes)
      @io.write(bytes.pack("C*"))
    end
    
    def read_bytes(bytes)
      source_from_io = @io.read(bytes)
      raise 'nothing read from source' unless source_from_io
      source_from_io.unpack("C*")
    end
  end
end