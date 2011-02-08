module AppConfig
  extend AppConfig::Processor

  FORMATS = ['string', 'array', 'hash', 'boolean']
  @@options = {}
  @@records = {}
  
  # Configure app config
  def self.configure(opts={})
    @@options[:model]   = opts[:model]        || Setting
    @@options[:key]     = opts[:key_field]    || 'keyname'
    @@options[:value]   = opts[:value_field]  || 'value'
    @@options[:format]  = opts[:format_field] || 'value_format'
  end
  
  # Load and process application settings
  def self.load
    @@records = fetch
  end
  
  # Delete all settings
  def self.flush
    @@records.clear
  end
  
  # Safe method to reload new settings
  def self.reload
    records = fetch rescue nil
    @@records = records || {}
  end
  
  # Manually set (or add) a key
  def self.set_key(keyname, value, format='string')
    raise InvalidKeyName, "Invalid key name: #{keyname}" if self.respond_to?(keyname)
    @@records[keyname] = process(value, format)
  end
  
  # Returns all configuration keys
  def self.options
    @@records.keys
  end
  
  # Get configuration option
  def self.[](key)
    @@records[key.to_s]
  end
  
  # Get configuration option by attribute
  def self.method_missing(method, *args)
    @@records[method.to_s]
  end
  
  # Returns true if configuration key exists
  def self.exist?(key)
    @@records.key?(key)
  end
  
  protected
  
  # Fetch data from model
  def self.fetch
    raise InvalidSource, 'Model is not defined!' if @@options[:model].nil?
    records = {}
    @@options[:model].send(:all).map do |c|
      records[c.send(@@options[:key].to_sym)] = process(
        c.send(@@options[:value].to_sym),
        c.send(@@options[:format].to_sym)
      )
    end
    records
  end
end
