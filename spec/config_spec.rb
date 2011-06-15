require 'spec_helper'

describe 'AppConfig' do
  before :all do
    establish_connection
    init_settings_table
    
    Setting.create(:keyname => 'foo', :value => 'bar', :value_format => 'string')
    AppConfig.configure
  end

  it 'should have no configuration options' do
    AppConfig.empty?.should == true
  end
  
  it 'should raise InvalidKeyName when setting value of a restricted key' do
    keys = AppConfig::RESTRICTED_KEYS
    keys.each do |k|
      proc { AppConfig.set_key(k, 'foo') }.should raise_error AppConfig::InvalidKeyName
    end
  end
    
  it 'should load setting item manually' do
    AppConfig.set_key('email_notifications', 'noreply@foo.com')
    AppConfig.exist?('email_notifications').should == true
  end
  
  it 'should provide hash-like and object-like access to options' do
    AppConfig.set_key('foo', 'bar')
    AppConfig['foo'].should == 'bar'
    AppConfig[:foo].should == 'bar'
    AppConfig.foo.should == 'bar'
  end
  
  it 'should return nil if option does not exist' do
    AppConfig[:foobar].should == nil
    AppConfig['foobar'].should == nil
    AppConfig.foobar.should == nil
  end
  
  it 'should erase all settings' do
    AppConfig.flush
    AppConfig.empty?.should == true
  end
  
  it 'should load data from database' do
    AppConfig.load
    AppConfig.keys.size.should == 1
    AppConfig.foo.should == 'bar'
  end
  
  it 'should reload data' do
    s = Setting.find_by_keyname('foo')
    s.update_attribute('value', 'TEST')
    
    AppConfig.reload
    AppConfig.keys.size.should == 1
    AppConfig.foo.should == 'TEST'
  end
end