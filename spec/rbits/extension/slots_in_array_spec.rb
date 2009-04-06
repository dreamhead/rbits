require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../../../lib/rbits/extension/slots_in_array')

describe RBits::Array do
  before(:each) do
    @desc = SubArrayDesc.new
    @io = RBits::BytesIO.new
  end
  
  describe 'slots in array' do
    before(:each) do
      @slots_klass = RBits::Type.struct(:slots_struct) do
        slots_in_array(2)

        u1 :bit
      end

      klass = RBits::Type.array(:slots_array) do
        size :type => :u1
        values :type => :slots_struct
      end

      @desc = klass.new
    end

    it 'occupies 2 slots' do
      @io.bytes = [0x04, 0x01, 0x02]
      bits = @desc.read(@io)
      bits[0].bit.should == 1
      bits[1].should be_nil
      bits[2].bit.should == 2
      bits[3].should be_nil
    end

    it 'ignores more slots' do
      first_slots_object = @slots_klass.new
      first_slots_object.bit = 1
      second_slots_object = @slots_klass.new
      second_slots_object.bit = 2
      bits = [first_slots_object, nil, second_slots_object, nil]
      @desc.write(@io, bits)
      @io.bytes.should == [0x04, 0x01, 0x02]
    end
  end
end

describe RBits::Switch do
    describe 'slots in array' do
    before(:each) do
      RBits::Type.struct(:slots_struct) do
        slots_in_array(2)

        u1 :bit
      end

      klass = RBits::Type.switch(:slots_switch) do
        tag :switch_tag, :type => :u1
        value :switch_value, :types => {1 => :u1, 2 => :slots_struct}
      end

      @desc = klass.new
      @io = RBits::BytesIO.new
    end

    it 'has same slots_in_array to slots_in_array in value' do
      @io.bytes = [0x02, 0x02]
      bits = @desc.read(@io)
      bits.slots_in_array.should == 2
    end

    it 'has 1 as slots_in_array to value without slots_in_array' do
      @io.bytes = [0x01, 0x02]
      bits = @desc.read(@io)
      bits.slots_in_array.should == 1
    end
  end
end