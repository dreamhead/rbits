require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe RBits::BytesIO do
  before(:each) do
    @bytes_io = RBits::BytesIO.new
  end

  it 'writes bytes' do
    @bytes_io.write_bytes([0x00])
    @bytes_io.write_bytes([0x01])
    @bytes_io.bytes.should == [0x00, 0x01]
  end
  
  it 'reads bytes' do
    @bytes_io.bytes = [0x01, 0x02]
    @bytes_io.read_bytes(1).should == [0x01]
  end
  
  it 'raises error if no bytes to read' do
    @bytes_io.bytes = []
    lambda { @bytes_io.read_bytes(1) }.should raise_error
  end
end

describe RBits::BytesIOWrapper do
  before(:each) do
    @io = StringIO.new
    @bytes_io = RBits::BytesIOWrapper.new(@io)
  end

  it 'writes bytes' do
    @bytes_io.write_bytes([0x00])
    @bytes_io.write_bytes([0x01])
    @io.string.should == "\x00\x01"
  end
  
  it 'reads bytes' do
    @io.string = "\x01\x02"
    @bytes_io.read_bytes(1).should == [0x01]
  end
  
  it 'raises error if no bytes to read' do
    @io.string = ''
    lambda { @bytes_io.read_bytes(1) }.should raise_error
  end
end