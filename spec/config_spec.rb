require 'helper'

class Setting < ActiveRecord::Base
  validates_presence_of   :keyname, :value, :value_format
  validates_uniqueness_of :keyname
end

describe 'AppConfig' do
  before :all do
    ActiveRecord::Base.establish_connection(
      :adapter => "sqlite3",
      :database => ":memory:"
    )
    
    ActiveRecord::Schema.define do
      create_table :settings do |t|
        t.string :keyname
        t.string :value
        t.string :value_format
      end
    end
    
    Setting.create(:keyname => 'foo', :value => 'bar', :value_format => 'string')
    AppConfig.configure
  end

  it 'should have no configuration options' do
    AppConfig.options.size.should == 0
  end
  
  it 'should raise InvalidKeyName' do
    proc { AppConfig.set_key('options', 'foo') }.should raise_error AppConfig::InvalidKeyName
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
  end
  
  it 'should load data from database' do
    AppConfig.load
    AppConfig.options.size.should == 1
    AppConfig.foo.should == 'bar'
  end
  
  it 'should reload data' do
    s = Setting.find_by_keyname('foo')
    s.update_attribute('value', 'TEST')
    
    AppConfig.load
    AppConfig.options.size.should == 1
    AppConfig.foo.should == 'TEST'
  end
end