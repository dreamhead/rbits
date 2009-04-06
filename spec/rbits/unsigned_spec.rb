require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class TestSubForUnsigned
  include RBits
  
  class << self
    def cleaup_fields
      field_descriptors.clear
    end
  end
end

describe RBits::Unsigned do
  before(:each) do
    @desc = RBits::Unsigned.new(1)
    @io = RBits::BytesIO.new
  end
  
  describe 'write' do
    it "writes fields correctly" do
      @desc.write(@io, 1)
      @io.bytes.should == [0x01]
    end

    it 'writes default value if the field is nil' do
      @desc = RBits::Unsigned.new(1, :default => 2)
      @desc.write(@io, nil)
      @io.bytes.should == [0x02]
    end
    
    it 'writes zero if the default value is not set' do
      @desc.write(@io, nil)
      @io.bytes.should == [0x00]
    end
    
    it 'write constant if the constant is set' do
      @desc = RBits::Unsigned.new(1, :const => 1)
      some_value = 2
      @desc.write(@io, some_value)
      @io.bytes.should == [0x01]
    end
  end
  
  describe 'read' do
    it "reads fields correctly" do
      @io.bytes = [0x01]
      @desc.read(@io).should == 1
    end
    
    it "reads constant" do
      @desc = RBits::Unsigned.new(1, :const => 1)
      @io.bytes = [0x01]
      @desc.read(@io).should == 1
    end
    
    it "raises error if constant is not correct" do
      @desc = RBits::Unsigned.new(1, :const => 1)
      @io.bytes = [0x02]
      lambda { @desc.read(@io) }.should raise_error
    end
    
    it 'raises error if can not read from io' do
      lambda { @desc.read(@io) }.should raise_error
    end
  end
  
  describe 'field' do
    after(:each) do
      TestSubForUnsigned.cleaup_fields
    end
    
    [1, 2, 4, 8].each do |size|
      it "generates u#{size}" do
        TestSubForUnsigned.send("u#{size}", :field)
        u = TestSubForUnsigned.new
        u.field = 1
        u.field.should == 1
      end
    end
  end
end