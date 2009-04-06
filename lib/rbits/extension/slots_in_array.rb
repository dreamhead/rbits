module RBits
  class Type
    class << self
      def slots_in_array(size)
        @slots_in_array = size
      end

      def __slots_in_array__
        @slots_in_array ||= 1
      end
    end

    def slots_in_array
      self.class.__slots_in_array__
    end
  end

  class Array < Type
    def read_array(size, io)
      array = []
      i = 0
      desc = self.class.value_descriptor

      while (i < size)
        array[i] = desc.read(io)
        i += slots(array[i])
      end

      array
    end

    def write_array(array, io)
      i = 0
      while (i < array.size)
        value = array[i]
        self.class.value_descriptor.write(io, value)
        i += slots(value)
      end
    end
    
    def slots(value)
      slots_value(value) || 1
    end

    def slots_value(value)
      value.respond_to?(:slots_in_array) && value.slots_in_array
    end
  end

  class Switch < Type
    def create_switch_object(tag, value)
      object = self.class.new
      object.send("#{self.class.tag_name}=", tag)
      object.send("#{self.class.value_name}=", value)
      if (value.respond_to?(:slots_in_array))
        object.extend(Slots)
      end
      object
    end
    
    module Slots
      def slots_in_array
        value = self.send("#{self.class.value_name}")
        value.slots_in_array
      end
    end
  end
end