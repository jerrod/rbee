module ExpressionEngine

  class Configuration

    def initialize(configuration_path, configuration_reader = nil)
      @configuration_path = configuration_path
      
      unless configuration_reader.nil?
        @configuration = {
          'database'      => configuration_reader.database,
          'control_panel' => configuration_reader.control_panel
        }
      end
    end

    def to_yaml
      template = ERB.new(File.read(File.dirname(File.dirname(__FILE__)) + '/templates/rbee.yml.erb'), nil, '-')
      template.result(binding)
    end

    def database
      self.configuration['database'].symbolize_keys
    end
    
    def control_panel
      self.configuration['control_panel'].symbolize_keys
    end
    
    def configuration
      @configuration ||= YAML.load_file("#{@configuration_path}/rbee.yml")
      @configuration
    end
    
  end

end