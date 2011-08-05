# AppConfig

AppConfig is a library to manage your (web) application dynamic settings with flexible access and configuration strategy.

Primary datasource for AppConfig is an ActiveRecord model.

## Installation

via rubygems:

    gem install app-config
  
via github:

    git clone git://github.com/sosedoff/app-config.git
    cd app-config
    gem build
    gem install app-config-x.y.z.gem
  
## Supported platforms

- Ruby 1.8.7
- Ruby EE 1.8.7
- Ruby 1.9.2
  
## Data Formats

You can use following formats:
- String
- Boolean
- Array
- Hash

String format is a default format. Everything is a string by default.

Boolean format is just a flag, values 'true', 'on', 'yes', 'y', '1' are equal to True. Everything else is False.

Array format is a multiline text which is transformed into array. Each evelemnt will be trimmed. Empty strings are ignored.

Hash format is special key-value string, "foo: bar, user: username", which is transformed into Hash instance.
Only format "keyname: value, keyname2: value2" is supported. No nested hashes allowed.

## Usage

AppConfig is designed to work with ActiveRecord model. Only ActiveRecord >= 3.0.0 is supported.

By default model "Setting" will be used as a data source.

Default migration:

    class CreateSettings < ActiveRecord::Migration
      def self.up
        create_table :settings do |t|
          t.string   :keyname,       :null => false, :limit => 64
          t.string   :name,          :null => false, :limit => 64
          t.text     :value,         :null => false
          t.string   :value_format,  :limit => 64,  :default => "string"
          t.string   :description,   :limit => 512, :null => false
          t.timestamps
        end
      end
  
      def self.down
        drop_table :settings
      end
    end

Now, configure:

    AppConfig.configure
  
If your settings model has a different schema, you can redefine columns:

  AppConfig.configure(
    :model  => Setting,           # define your model as a source
    :key    => 'KEYNAME_FIELD',   # field that contains name
    :format => 'FORMAT_FIELD',    # field that contains key format
    :value  => 'VALUE_FIELD',     #field that contains value data
  )
  
Load all settings somewhere in your application. In Rails it should be initializer file.

    AppConfig.load
  
Configuration in Rails 3: (you can put this into environment/ENV or application.rb)
Make sure your application does not have any critical parts depending on AppConfig at startup.

    config.after_initialize do
      AppConfig.configure(:model => Setting)
      AppConfig.load if Setting.table_exists?
    end

AppConfig gives you 3 ways to access variables:

    AppConfig.my_setting      # method-like
    AppConfig[:my_setting]    # hash-like by symbol key
    AppConfig['my_setting']   # hash-like by string key
  
You can define settings items manually. NOTE: THESE KEYS WILL BE REMOVED ON RELOAD/LOAD.

    AppConfig.set_key('KEYNAME, 'VALUE', 'FORMAT')
  
Everytime you change your settings on the fly, use reload:

    AppConfig.reload
  
Cleanup everything:

    AppConfig.flush

== Copyright

Copyright (c) 2011 Dan Sosedoff.