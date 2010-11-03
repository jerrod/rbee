class TemplateGroup < ActiveRecord::Base
  set_table_name 'exp_template_groups'
  set_primary_key 'group_id'

  has_many :templates, :foreign_key => :group_id
  
  validates_presence_of :group_order
  
  def name
    self.group_name
  end
  
end