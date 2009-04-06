require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class RBitsTestClass
  include RBits
  
  u1 :first
  u1 :second
  u1 :third
end

describe RBits do
  before(:each) do
    @bits = RBitsTestClass.new
    @io = StringIO.new
  end
    
  it 'adds getter and setter' do
    @bits.first = 1
    @bits.first.should == 1
  end
  
  describe 'read/write object' do
    it 'writes object sequently' do
      @bits.first = 1
      @bits.second = 2
      @bits.third = 6
      @bits.write(@io)
      @io.string.should == "\001\002\006"
    end
    
    it 'reads object sequently' do
      @io.string = "\001\002\006"
      @bits = RBitsTestClass.read(@io)
      @bits.first.should == 1
      @bits.second.should == 2
      @bits.third.should == 6
    end
  end
  
  describe 'read object with bytes' do
    it 'reads from bytes' do
      @bits = RBitsTestClass.read_bytes([0x01, 0x02, 0x06])
      @bits.first.should == 1
      @bits.second.should == 2
      @bits.third.should == 6
    end
    
    it 'raises exception with field info if something wrong' do
      lambda { @bits = RBitsTestClass.read_bytes([]) }.should raise_error(RuntimeError,
        'Exception for [first] with [nothing read from source]')
    end
  end

  describe 'initialilzation with block' do
    it 'initializes object with block' do
      @bits = RBitsTestClass.new do |bits|
        bits.first = 0x01
        bits.second = 0x02
        bits.third = 0x06
      end
      
      @bits.first.should == 1
      @bits.second.should == 2
      @bits.third.should == 6
    end
  end
end