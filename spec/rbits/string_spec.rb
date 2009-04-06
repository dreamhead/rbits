require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class SubStringDesc < RBits::String
  size :type => :u2
end

describe RBits::String do
  describe "read" do
    it "read string correctly" do
      @io = RBits::BytesIO.new([0x06, 0x3C, 0x69, 0x6E, 0x69, 0x74, 0x3E])
      @desc = RBits::String.new
      
      @desc.read(@io).should == "<init>"
    end
  end
  
  describe "write" do
    it "write string correctly" do
      @io = RBits::BytesIO.new
      @desc = RBits::String.new
      
      target = "<init>"
      @desc.write(@io, target)
      @io.bytes.should == [0x06, 0x3C, 0x69, 0x6E, 0x69, 0x74, 0x3E]
    end
  end
  
  describe "options" do
    it "read string correctly" do
      @io = RBits::BytesIO.new([0x00, 0x06, 0x3C, 0x69, 0x6E, 0x69, 0x74, 0x3E])
      @desc = SubStringDesc.new
      
      @desc.read(@io).should == "<init>"
    end
    
    it "write string correctly" do
      @io = RBits::BytesIO.new
      @desc = SubStringDesc.new

      target = "<init>"
      @desc.write(@io, target)
      @io.bytes.should == [0x00, 0x06, 0x3C, 0x69, 0x6E, 0x69, 0x74, 0x3E]
    end
  end
  
  describe 'string type' do
    before(:each) do
      klass = RBits::Type.string(:new_string)
      @desc = klass.new
    end
    
    it 'defines string type' do
      RBits::Type.should have_field_type(:new_string)
    end
    
    it 'sets options correctly' do
      @io = RBits::BytesIO.new([0x06, 0x3C, 0x69, 0x6E, 0x69, 0x74, 0x3E])
      @desc.read(@io).should == "<init>"
    end
  end
end