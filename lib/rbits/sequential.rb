module RBits
  module Sequential
    def self.included(base)
      base.extend SequentialClassMethods if base.is_a? Class
    end
  
    def self.define_field_type symbol
      SequentialClassMethods.send :define_method, symbol do |field_id, *args|
        options = args[0] || {}
        type_desc = Type.create_field(symbol, options)
        add_field_desc(field_id, type_desc)
      end
    end

    def __fields__
      @fields ||= {}
    end
  
    module SequentialClassMethods
      FieldDescriptor = Struct.new(:field_id, :descriptor)
    
      def add_field_desc(field_id, type_desc)
        raise "duplicated defination for #{field_id}" if has_desc_for?(field_id)
        field_descriptors << FieldDescriptor.new(field_id, type_desc)
      
        field_desc_added(field_id) if respond_to? :field_desc_added
      end
    
      def has_desc_for?(field_id)
        field_descriptors.any? {|desc| desc.field_id == field_id }
      end
    
      def field_descriptors
        @field_descriptors ||= []
      end

      def field_desc_added field_id
        define_method(field_id) do
          __fields__[field_id]
        end

        define_method("#{field_id}=") do |value|
          __fields__[field_id] = value
        end
      end
    end
  end
end