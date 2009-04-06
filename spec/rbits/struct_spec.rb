require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class StructBits
  attr_accessor :bit1, :bit2
end

class SubStructhDesc < RBits::Struct
  u1 :bit1
  u1 :bit2

  def text
    "#{self.bit1} #{self.bit2}"
  end
end

describe RBits::Struct do
  before(:each) do
    @desc = SubStructhDesc.new
    @io = RBits::BytesIO.new
    @bits = StructBits.new
  end
  
  describe "write" do
    it "writes struct correctly" do
      @bits.bit1 = 1
      @bits.bit2 = 2
      @desc.write(@io, @bits)
      @io.bytes.should == [0x01, 0x02]
    end
  end
  
  describe "read" do
    it "reads struct correctly" do
      @io.bytes = [0x01, 0x02]
      @bits = @desc.read(@io)
      @bits.bit1.should == 1
      @bits.bit2.should == 2
    end

    it 'reads same struct type' do
      @io.bytes = [0x01, 0x02]
      @bits = @desc.read(@io)
      @bits.text.should == '1 2'
    end
  end
  
  describe 'struct type' do
    before(:each) do
      klass = RBits::Type.struct(:new_struct) do
        u1 :bit1
        u1 :bit2
      end
      @desc = klass.new
    end
    
    it 'defines struct type' do
      RBits::Type.should have_field_type(:new_struct)
    end
    
    it 'sets options correctly' do
      @io.bytes = [0x01, 0x02]
      @bits = @desc.read(@io)
      @bits.bit1.should == 1
      @bits.bit2.should == 2
    end
  end
end