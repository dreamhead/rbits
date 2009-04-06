module RBits
  include Sequential

  module RBitsClassMethods
    def read(io)
      read_with_bytes_io(BytesIOWrapper.new(io))
    end

    def read_bytes(bytes)
      read_with_bytes_io(BytesIO.new(bytes))
    end

    private
    def read_with_bytes_io(bytes_io)
      obj = self.new
      self.field_descriptors.each do |fd|
        begin
          obj.__fields__[fd.field_id] = fd.descriptor.read(bytes_io)
        rescue Exception => e
          raise "Exception for [#{fd.field_id}] with [#{e.message}]"
        end
      end
      obj
    end
  end

  def self.included(base)
    if base.is_a? Class
      base.extend RBitsClassMethods
      base.extend SequentialClassMethods
    end
  end
    
  def initialize
    yield self if block_given?
  end
    
  def write(io)
    write_with_bytes_io(BytesIOWrapper.new(io))
  end

  private
  def write_with_bytes_io(bytes_io)
    self.class.field_descriptors.each do |fd|
      fd.descriptor.write(bytes_io, __fields__[fd.field_id])
    end
  end
end