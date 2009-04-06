module RBits
  class Struct < Type
    include Sequential
  
    def initialize(options = {})
    end
  
    def write(io, value)
      self.class.field_descriptors.each do |fd|
        fd.descriptor.write(io, value.send(fd.field_id))
      end
    end
  
    def read(io)
      target = self.class.new
      self.class.field_descriptors.each do |fd|
        target.send("#{fd.field_id}=", fd.descriptor.read(io))
      end
      target
    end
  end
end