module RBits
  class Switch < Type
    class << self
      attr_reader :tag_name, :tag_descriptor, :value_name, :value_types
      attr_accessor :value_descriptors
    
      def tag(name, options)
        @tag_name = name
        @tag_descriptor = Type.create_field(options[:type])
        self.send(:attr_accessor, name.to_sym)
      end
    
      def value(name, options)
        @value_name = name
        @value_types = options[:types]
        self.send(:attr_accessor, name.to_sym)
      end
    end

    def initialize(options = {})
    end
  
    def write(io, object)
      tag = object.send(self.class.tag_name)
      self.class.tag_descriptor.write(io, tag)
      value_descriptor(tag).write(io, object.send(self.class.value_name))
    end
  
    def read(io)
      tag = self.class.tag_descriptor.read(io)
      value = value_descriptor(tag).read(io)
      create_switch_object(tag, value)
    end
  
    private
    def value_descriptor(value)
      type = value_type(value)
      value_descriptors[type] ||= Type.create_field(type)
    end
  
    def value_type(value)
      self.class.value_types[value] ||= (raise "Unknown reference value #{value}")
    end
  
    def value_descriptors
      self.class.value_descriptors ||= {}
    end

    def create_switch_object(tag, value)
      object = self.class.new
      object.send("#{self.class.tag_name}=", tag)
      object.send("#{self.class.value_name}=", value)
      object
    end
  end
end