module RBits
  BITS_IN_BYTE = 8
end

class Integer
  def to_bytes(unsigned_size = 1)
    targets = []
    value = self
    unsigned_size.times do
      targets << (value & 0xFF)
      value >>= RBits::BITS_IN_BYTE
    end
    targets.reverse
  end
end

class Array
  def to_unsigned
    current_value = 0
    self.each do |value|
      current_value <<= RBits::BITS_IN_BYTE
      current_value |= value
    end
    current_value
  end
end