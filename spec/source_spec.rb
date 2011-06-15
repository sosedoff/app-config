require 'spec_helper'

describe 'AppConfig' do
  before :all do
    ActiveRecord::Base.establish_connection(
      :adapter => "sqlite3",
      :database => ":memory:"
    )
    
    ActiveRecord::Schema.define do
      create_table :items do |t|
        t.string :name
        t.string :data
        t.string :fmt
      end
    end
    
    Item.create(:name => 'foo', :data => 'bar', :fmt => 'string')
  end
  
  it 'should raise InvalidSource error if source model is not defined' do
    AppConfig.configure
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