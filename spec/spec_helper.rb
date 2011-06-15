$:.unshift File.expand_path("../..", __FILE__)

require 'simplecov'
SimpleCov.start do
  add_group 'AppConfig', 'lib/app-config'
end

require 'app-config'

class Setting < ActiveRecord::Base
  validates_presence_of   :keyname, :value, :value_format
  validates_uniqueness_of :keyname
end

class Item < ActiveRecord::Base ; end

class FakeModel ; end

def establish_connection
  ActiveRecord::Base.establish_connection(
    :adapter => "sqlite3",
    :database => ":memory:"
  )
end

def init_settings_table
  ActiveRecord::Schema.define do
    create_table :settings do |t|
      t.string :keyname
      t.string :value
      t.string :value_format
    end
  end
end

def init_custom_table
  ActiveRecord::Schema.define do
    create_table :items do |t|
      t.string :name
      t.string :data
      t.string :fmt
    end
  end
end
