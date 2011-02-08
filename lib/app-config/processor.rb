module AppConfig
  module Processor
    # Process string value
    def process_string(value)
      value.strip
    end

    # Process array of strings
    def process_array(value)
      value.split("\n").map { |s| s.to_s.strip }.compact.select { |s| !s.empty? }
    end
  
    # Parse boolean string
    def process_boolean(value)
      ['true', 'on', 'yes', 'y', '1'].include?(value.to_s.downcase)
    end
    
    # Parse hash string
    # value should be in the following format:
    # "keyname: value, key2: value2"
    def process_hash(value)
      result = {}
      unless value.empty?
        value.split(",").each do |s|
          k,v = s.split(':').compact.map { |i| i.to_s.strip }
          result[k] = v.to_s
        end
      end
      result
    end
    
    # Process data value for the format
    def process(data, type)
      raise InvalidType, 'Type is invalid!' unless FORMATS.include?(type)
      send("process_#{type}".to_sym, data.to_s)
    end
  end
end
