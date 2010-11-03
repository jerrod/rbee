class Template < ActiveRecord::Base
  set_table_name 'exp_templates'
  set_primary_key 'template_id'

  EXTENSION = '.php'
  attr_accessor :file
  
  validates_presence_of :hits, :template_data, :group_id, :refresh, :template_notes
  
  
  belongs_to :template_group, :foreign_key => :group_id
  belongs_to :site

  after_save :save_file

  def after_initialize
    retrieve_file
  end

  def before_validation
    self.hits ||= 0
    self.template_data ||= "this is the #{self.name} template"
    self.refresh ||= 'y'
    self.template_notes ||= "Created by EEFixer"
    self.save_template_file = 'y'
  end
  
  def save_template_file=(should_save)
    value = should_save ? 'y' : 'n'
    write_attribute(:save_template_file, value)
  end

  def has_file?
    save_file = read_attribute(:save_template_file) == 'y' ? true : false
    save_file = save_file && !self.preferences[:tmpl_file_basepath].blank?
    save_file
  end
  
  def name
    self.template_name
  end
  
  def preferences
    self.site.preferences[:template]
  end
  
  def path
    File.join(EE_ROOT, self.template_group.group_name, self.template_name)
  end
  
  def retrieve_file
      path  = EE_ROOT
      if File.exists?("#{self.path}#{EXTENSION}")
        @file = File.open("#{self.path}#{EXTENSION}", 'w') unless path.blank?
      else
        save_file
      end
    rescue
      save_file
  end
  
  def save_file
    return false if self.new_record?
    if  !File.exists?(File.join(EE_ROOT, self.template_group.group_name))
      FileUtils.mkpath(File.join(EE_ROOT, self.template_group.group_name))
    end
    
    File.open("#{self.path}#{EXTENSION}", 'w') do |f|
      f.write self.template_data
    end
  end
end
