module ExpressionEngine
  
  class Preference

    include Enumerable
    
    attr_accessor :data
    
    def initialize(serialized_data)
      @data = PHP.unserialize(serialized_data).symbolize_keys rescue []
    end
    
    def [](key)
      @data[key] rescue nil
    end
    
    def []=(key, value)
      @data[key] = value rescue nil
    end
    
    def each(&block)
      @data.each(&block) rescue nil
    end
    
    def to_s
      PHP.serialize(@data.stringify_keys) rescue nil
    end
    
  end
  
end