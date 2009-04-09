module Rojam
  class ClassFile < RBits::Base
    u4 :magic, :const => 0xCAFEBABE
    u2 :minor_version
    u2 :major_version
    constant_pool :cp_info
    u2 :access_flags
    u2 :this_class
    u2 :super_class
    interfaces :interfaces
    fields :fields
    methods :methods
    attributes :attributes
    
    def to_node
      ClassNodeParser.new.parse(self)
    end
  end
end