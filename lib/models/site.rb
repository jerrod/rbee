class Site < ActiveRecord::Base
  set_table_name 'exp_sites'
  set_primary_key 'site_id'
  
  has_many :template_groups
  has_many :templates

  PREFERENCE_PATHS = [
    'system:theme_folder_path',
    'system:captcha_path',
    'template:tmpl_file_basepath',
    'member:avatar_path',
    'member:photo_path',
    'member:sig_img_path',
    'member:prv_msg_upload_path'
  ]

  before_save :update_preferences

  def after_initialize
    @preferences = Hash.new
  end

  def name
    self.site_label
  end
  
  def slug
    self.site_name
  end
 
  def preferences
    if @preferences.empty?
      preference_map.each do |key, method_base|
        @preferences[key] = ExpressionEngine::Preference.new(self.send(method_base.to_sym))
      end
    end
    @preferences
  end
  
  def update_preferences
    preference_map.each do |key, method_base|
      self.send("#{method_base}=".to_sym, @preferences[key].to_s)
    end
  end

  def root_path=(other)
    pattern = Regexp.quote(self.root_path)
    PREFERENCE_PATHS.each do |preference|
      group, setting = preference.split(':')
      self.preferences[group.to_sym][setting.to_sym].gsub!(/^#{pattern}/, other)
    end
  end

  def root_path
    common_elements = nil
    
    PREFERENCE_PATHS.each do |preference|
      group, setting = preference.split(':')
      path = self.preferences[group.to_sym][setting.to_sym].split('/')

      unless path.empty?
        common_elements = path if common_elements.nil?
        common_elements = common_elements & path
      end
    end
    
    common_elements.join('/')
  end

  private
  def preference_map
    [:system, :mailing_list, :member, :template, :weblog].inject({}) do |list, key|
      list.merge(key => "site_#{key.to_s.gsub('_', '')}_preferences")
    end
  end

end