module ExpressionEngine
  
  class ConfigurationReader

    DEFAULTS = {
      :hostname       => 'localhost',
      :theme_path     => 'themes',
      :template_path  => 'templates',
      :captcha_path   => 'images/captcha',
      :avatar_path    => 'images/avatars',
      :photo_path     => 'images/member_photos'
    }
    
    def initialize(configuration_file)
      @configuration_file = configuration_file
    end
    
    def database
        database = {}
        pattern = /^\$conf\['([^']+)'\]\s+=\s+"([^"]+)";$/
        mapping = {
          'db_hostname' => :host, 
          'db_username' => :username, 
          'db_password' => :password, 
          'db_name'     => :database,
          'db_type'     => :adapter
        }
      
        matches = File.read(@configuration_file).scan(pattern)
      
        matches.each do |match|
          key = match[0]
          database[mapping[key]] = match[1] if mapping.has_key?(key)
        end
        
        database
    end
    
    def control_panel
      DEFAULTS
    end
  end
  
end