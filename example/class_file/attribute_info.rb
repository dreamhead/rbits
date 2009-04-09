module Rojam
  RBits::Type.array(:code) do
    size :type => :u4
    values :type => :u1
  end

  RBits::Type.array(:exceptions) do
    size :type => :u2
    values :type => :u1
  end

  RBits::Type.array(:exception_index_table) do
    size :type => :u2
    values :type => :u2
  end

  class ExceptionAttribute
    include RBits
    
    exception_index_table :table
  end
  
  class CodeAttribute
    include RBits
    
    u2 :max_stack
    u2 :max_locals
    code :code
    exceptions :exceptions
    attributes :attributes
  end

  RBits::Type.struct(:line_number_info) do
    u2 :start_pc
    u2 :line_number
  end

  RBits::Type.array(:line_number_table) do
    size :type => :u2
    values :type => :line_number_info
  end
  
  class LineNumberTableAttribute
    include RBits
    
    line_number_table :table
  end

  class ConstantValueAttribute
    include RBits
    
    u2 :constantvalue_index
  end
end