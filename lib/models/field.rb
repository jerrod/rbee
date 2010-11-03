class Field < ActiveRecord::Base
  set_table_name 'exp_weblog_fields'
  set_primary_key 'group_id'
  belongs_to :field_group, :foreign_key=>:group_id
  
  validates_presence_of :group_id, :field_name, :field_label, :field_pre_field_id
  
  before_validation :set_defaults
  
  def set_defaults
    self.field_pre_field_id ||= 0
    self.field_related_id   ||= 0
    self.field_order        ||= Field.count + 1
    self.field_instructions ||= ""
    self.field_list_items   ||= ""
    self.field_related_max  ||= 0
    self.field_pre_blog_id  ||= 0
    self.field_maxl         ||= 128
  end
  
  def name
    self.field_name
  end
  
  def name=(field_name)
    self.field_name=field_name
  end  
  
  def description
    self.field_description
  end
  def description=(field_description)
    self.field_description=(field_description)
  end  
  FIELD_TYPES = ["text", "textarea", "date", "file"]
end