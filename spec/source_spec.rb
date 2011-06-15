require 'spec_helper'

describe 'AppConfig' do
  before :all do
    establish_connection
    init_custom_table
    
    Item.create(:name => 'foo', :data => 'bar', :fmt => 'string')
  end
  
  it 'should raise InvalidSource error if source model is not defined' do
    AppConfig.configure
    proc { AppConfig.load }.should raise_error AppConfig::InvalidSource
  end
  
  it 'should raise InvalidSource error if source model was not found' do
    AppConfig.configure(:model => FakeModel)
    proc { AppConfig.load }.should raise_error AppConfig::InvalidSource
  end
  
  it 'should validate custom source fields' do
    AppConfig.configure(
      :model  => Item,
      :key    => 'name',
      :value  => 'data',
      :format => 'fmt'
    )
    
    proc { AppConfig.load }.should_not raise_error AppConfig::InvalidSource
    
    AppConfig.configure(
      :model  => Item,
      :key    => 'fake_field',
      :value  => 'data',
      :format => 'fmt'
    )
    
    proc { AppConfig.load }.should raise_error AppConfig::InvalidSource
  end
  
  it 'should load data from custom model' do
    
    AppConfig.configure(
      :model  => Item,
      :key    => 'name',
      :value  => 'data',
      :format => 'fmt'
    )
    
    AppConfig.load
    AppConfig.exist?('foo').should == true
    AppConfig.foo.should == 'bar'
  end
end