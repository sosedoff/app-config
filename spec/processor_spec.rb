require 'helper'

describe 'Processor' do
  include AppConfig::Processor

  it 'should raise InvalidType expection on invalid data type' do
    proc { process('foo', 'bar') }.should raise_error AppConfig::InvalidType
  end
  
  it 'should return an empty object if data is nil' do
    process(nil, 'string').should == ''
    process(nil, 'array').should == []
    process(nil, 'boolean').should == false
    process(nil, 'hash').should == {}
  end
  
  it 'should process and trim string data' do
    data = "  Foo bar \r\n  "
    result = process(data, 'string')
    
    result.should be_a_kind_of String
    result.empty?.should_not be true
    result.should == 'Foo bar'
  end
  
  it 'should process and trim array data' do
    data = "str1\r\nstr2\r\nstr3 \r\n\r\n"    
    target = ['str1', 'str2', 'str3']
    
    result = process(data, 'array')
    result.should be_a_kind_of Array
    result.size.should == 3
    result.should == target
  end
  
  it 'should process empty array data' do
    result = process("\r\n", 'array')
    result.should be_a_kind_of Array
    result.size.should == 0
  end
  
  it 'should process hash data' do
    data = "key: value1, key2: value2, key3: hello world, key 4: text data ,"
    result = process(data, 'hash')
    
    result.should be_a_kind_of Hash
    result.empty?.should_not == true
    result.size.should == 4
    result.keys.should include 'key 4'
    result['key 4'].should == 'text data'
  end
  
  it 'should process a boolean data' do
    ['yes', 'y', '1'].each { |v| process(v, 'boolean').should == true }
    ['', 'no', 'n', '0', 'other'].each { |v| process(v, 'boolean').should == false }
  end
end