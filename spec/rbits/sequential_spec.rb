require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class TestSequential
  include RBits::Sequential
end

class TestFieldDesc < RBits::Type
  field_type :desc
  attr_accessor :options
  
  def initialize(options)
    @options = options
  end
end

describe RBits::Sequential do
  include RBits::Sequential
  
  def self.cleaup_fields
    field_descriptors.clear
  end
  
  def fields
    @fields ||= {}
  end
  
  after(:each) do
    self.class.cleaup_fields
  end
  
  describe "add_field_desc" do
    before(:each) do
      @field = RBits::Unsigned.new(1)
      self.class.add_field_desc(:field, @field)
    end

    it 'adds field correctly' do
      self.class.should have_desc_for(:field)
    end
    
    it 'raises error if field has been defined' do
      lambda { self.class.add_type_desc(:field, @field) }.should raise_error
    end
    
    it 'adds same name field for different sub class' do
      lambda { TestSequential.add_field_desc(:field, @field) }.should_not raise_error
    end
  end
  
  describe "field type" do
    it 'defines new field with test type' do
      RBits::Sequential.define_field_type :desc
      self.class.desc :field
      self.class.should have_desc_for(:field)
    end
    
    it 'raise error for undefined type' do
      lambda { TestSubBits.unknown :field }.should raise_error
    end
  end
end