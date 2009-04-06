require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class SwitchBits
  attr_accessor :switch_tag
  attr_accessor :switch_value
end

class SubSwitchDesc < RBits::Switch
  tag :switch_tag, :type => :u1
  value :switch_value, :types => {1 => :u1, 2 => :u2}
end

describe RBits::Switch do
  describe "class options" do
    before(:each) do
      @desc = SubSwitchDesc.new
      @io = RBits::BytesIO.new
      @bits = SwitchBits.new
    end
    
    describe "write" do
      it "writes switch field for ref 1 correctly" do
        @bits.switch_tag = 1
        @bits.switch_value = 1
        @desc.write @io, @bits
        @io.bytes.should == [0x01, 0x01]
      end
    
      it "writes switch field for ref 2 correctly" do
        @bits.switch_tag = 2
        @bits.switch_value = 2
        @desc.write @io, @bits
        @io.bytes.should == [0x02, 0x00, 0x02]
      end
    
      it "raises error without ref value" do
        @bits.switch_tag = -1
        @bits.switch_value = -1
        lambda { @desc.write(@io, @bits) }.should raise_error
      end
    end
    
    describe "read" do
      it "reads switch field for ref 1 correctly" do
        @io.bytes = [0x01, 0x01]
        bits = @desc.read(@io)
        bits.switch_tag.should == 1
        bits.switch_value.should == 1
      end
    
      it "reads switch field for ref 2 correctly" do
        @io.bytes = [0x02, 0x00, 0x02]
      
        bits = @desc.read(@io)
        bits.switch_tag.should == 2
        bits.switch_value.should == 2
      end
    
      it "raises error without ref value" do
        @io.bytes = [0x03]
        lambda { @desc.read(@io) }.should raise_error
      end
    end
  end
  
  describe 'switch type' do
    before(:each) do
      klass = RBits::Type.switch(:new_switch) do      
        tag :switch_tag, :type => :u1
        value :switch_value, :types => {1 => :u1, 2 => :u2}
      end
      @desc = klass.new
    end
    
    it 'defines struct type' do
      RBits::Type.should have_field_type(:new_switch)
    end
    
    it 'sets options correctly' do 
      @io = RBits::BytesIO.new
      @io.bytes = [0x01, 0x01]
      bits = @desc.read(@io)
      bits.switch_tag.should == 1
      bits.switch_value.should == 1
    end
  end
end