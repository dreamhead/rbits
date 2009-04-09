module Rojam
  class ClassFileGenerator
    def generate class_node
      ClassFile.new do |file|
        file.magic = 0xCAFEBABE
        file.major_version = class_node.version
        file.minor_version = 0
        file.access_flags = class_node.access

        @writer = ConstantPoolWriter.new
        file.this_class = @writer.type_name(class_node.name)
        file.super_class = @writer.type_name(class_node.super_name)

        file.interfaces = []
        class_node.interfaces.each {|i| file.interfaces << @writer.type_name(i) }
        
        file.cp_info = @writer.cp_info
      end
    end
  end
end