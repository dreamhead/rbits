require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class SubArrayDesc < RBits::Array
  size :type => :u1
  values :type => :u1
end

class SubArrayDescWithReadWriteProc < RBits::Array
  size :type => :u1,
    :read_proc => lambda {|size| size - 1},
    :write_proc => lambda {|size| size + 1}
  values :type => :u1
end

describe RBits::Array do
  before(:each) do
    @desc = SubArrayDesc.new
    @io = RBits::BytesIO.new
  end
  
  describe "write" do
    it "writes array field correctly" do
      @bits = [1, 2]
      @desc.write(@io, @bits)
      @io.bytes.should == [0x02, 0x01, 0x02]
    end
  end

  describe 'read' do
    it 'reads array field correctly' do
      @io.bytes = [0x02, 0x01, 0x02]
      bits = @desc.read(@io)
      bits.should == [1, 2]
    end
  end

  describe 'options' do
    it 'has difference between size and size reference for read' do
      @desc = SubArrayDescWithReadWriteProc.new
      @io.bytes = [0x02, 0x01]
      bits = @desc.read(@io)
      bits.should == [1]
    end

    it 'has difference between size and size reference for write' do
      @desc = SubArrayDescWithReadWriteProc.new
      @bits = [1]
      @desc.write(@io, @bits)
      @io.bytes.should == [0x02, 0x01]
    end
  end

  describe 'array type' do
    before(:each) do
      klass = RBits::Type.array(:new_array) do
        size :type => :u1
        values :type => :u1
      end
      @desc = klass.new
    end

    it 'defines array type' do
      RBits::Type.should have_field_type(:new_array)
    end

    it 'sets options correctly' do
      @bits = [1, 2]
      @desc.write(@io, @bits)
      @io.bytes.should == [0x02, 0x01, 0x02]
    end
  end
end