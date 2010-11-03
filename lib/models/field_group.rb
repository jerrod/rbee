class FieldGroup < ActiveRecord::Base
  set_table_name 'exp_field_groups'
  set_primary_key 'group_id'

  has_many :fields, :foreign_key=>:group_id

end