module ExpressionEngine
  class Initializer

    CONFIGURATION_FILENAME = 'rbee.yml'
    
    attr_accessor :configuration
    
    def self.root_directory?(path)
      directory = Dir.new(path)
      directory.entries.include?('index.php') && directory.entries.include?('path.php')
    end

    def initialize(path)
      @current_path  = path
    end
    
    def root_path
      path = self.configuration_path
      path = find_in_path(@current_path) {|path| self.class.root_directory?(path) } if path.nil?
      path
    end

    def configuration_path
      find_in_path(@current_path) {|path| File.exist?("#{path}/#{CONFIGURATION_FILENAME}")}
    end

    def system_path
      config_file = 'config.php'
      paths = Dir["#{self.root_path}/**/#{config_file}"]
      paths.first.sub(/\/#{Regexp.escape(config_file)}$/, '') unless paths.empty?
    end
    
    def configuration_file
      "#{self.configuration_path}/#{CONFIGURATION_FILENAME}" unless self.configuration_path.nil?
    end
    
    def source_configuration_file
      "#{self.system_path}/config.php" if self.system_path
    end
    
    def initialized?
      !self.configuration_file.nil?
    end

    def write_configuration
      File.open("#{self.root_path}/#{CONFIGURATION_FILENAME}", 'w') {|f| f << self.configuration.to_yaml }
    end

    private 
    def find_in_path(path, &block)
      full_path = nil
      current_path = path

      while full_path.nil? && current_path != '/'
        if block.call(current_path) == true
          full_path = current_path
        else
          current_path = File.expand_path("#{current_path}/..")
        end
      end
      full_path    
    end

  end  
end

