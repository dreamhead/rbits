require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "unsigned extension" do
  it "converts unsigned to bytes array" do
    1.to_bytes.should == [0x01]
    1.to_bytes(2).should == [0x00, 0x01]
    256.to_bytes(2).should == [0x01, 0x00]
  end
  
  it "converts bytes array to unsigned" do
    [0x01].to_unsigned.should == 1
    [0x01, 0x00].to_unsigned.should == 256
  end
end

