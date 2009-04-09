module Rojam
  module ConstantPoolReaderHelper
    def type_name index
      cp_value = constant_value(index)
      constant_value(cp_value.name_index) if (cp_value)
    end
      
    def method_owner_name index
      cp_value = constant_value(index)
      type_name(cp_value.class_index) if (cp_value)
    end
    
    def name_and_desc index
      cp_value = constant_value(index)
      if (cp_value)
        name_and_type_index = cp_value.name_and_type_index
        value = constant_value(name_and_type_index)
        if (value)
          [constant_value(value.name_index), constant_value(value.descriptor_index)]
        end
      end
    end

    def string_value index
      cp_value = constant_value(index)
      constant_value(cp_value.string_index) if (cp_value)
    end

    def int_value index
      value = constant_value(index)
      value.bytes if value
    end

    def long_value index
      value = constant_value(index)
      [value.high_bytes, value.low_bytes].to_unsigned if value
    end

    def value index
      info = constant_info(index)
      case info.tag
      when CONSTANT_INTEGER_TAG
        int_value(index)
      when CONSTANT_LONG_TAG
        long_value(index)
      else
        string_value(index)
      end
    end
  end
  
  class ConstantPoolReader
    include ConstantPoolReaderHelper
    
    def initialize cp_infoes
      @cp_infoes = cp_infoes
    end
    
    def constant_value index
      cp_info = constant_info(index)
      cp_info.info if cp_info
    end

    private
    def constant_info index
      @cp_infoes[index - 1]
    end
  end

  class ConstantPoolWriter
    attr_reader :cp_info
    
    def initialize
      @cp_info = []
    end
    
    def type_name name
      @cp_info << CpClass.new(name)
      @cp_info << CpClass.new(Struct.new(:name_index).new(cp_info.size))
      @cp_info.size
    end

    private
    CpClass = Struct.new(:info)
  end
end