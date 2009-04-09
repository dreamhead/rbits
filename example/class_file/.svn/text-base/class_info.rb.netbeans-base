module Rojam
  RBits::Type.array(:interfaces) do
    size :type => :u2
    values :type => :u2
  end

  RBits::Type.array(:info) do
    size :type => :u4
    values :type => :u1
  end

  RBits::Type.struct(:attribute_info) do
    u2 :attribute_name_index
    info :infoes
  end

  RBits::Type.array(:attributes) do
    size :type => :u2
    values :type => :attribute_info
  end

  RBits::Type.struct(:field_info) do
    u2 :access_flags
    u2 :name_index
    u2 :descriptor_index
    attributes :attributes
  end

  RBits::Type.array(:fields) do
    size :type => :u2
    values :type => :field_info
  end

  RBits::Type.struct(:method_info) do
    u2 :access_flags
    u2 :name_index
    u2 :descriptor_index
    attributes :attributes
  end

  RBits::Type.array(:methods) do
    size :type => :u2
    values :type => :method_info
  end
end