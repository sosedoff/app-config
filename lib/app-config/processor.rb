module AppConfig
  module Processor
    def process_string(value)
      value.strip
    end

    def process_array(value)
      value.split("\n").map { |s| s.to_s.strip }.compact.select { |s| !s.empty? }
    end
  
    def process_boolean(value)
      case value.to_s.downcase
        when 'yes', 'y', '1' then
          true
        when 'no', 'n', '0' then
          false
        else
          false
      end
    end

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

    def process(data, type)
      raise InvalidType, 'Type is invalid!' unless FORMATS.include?(type)
      send("process_#{type}".to_sym, data.to_s)
    end
  end
end
