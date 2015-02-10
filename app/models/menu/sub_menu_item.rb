# == Schema Information
#
# Table name: menu_items
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  caption    :string(255)
#  type       :string(255)
#  position   :integer
#  parent_id  :integer
#  page_id    :integer
#  url        :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class SubMenuItem < MenuItem 
#uploaders
#friendly_id
#instances
#attrs
#associations
  belongs_to :global_menu_item, class_name: "GlobalMenuItem", foreign_key: "parent_id"
#scopes
#validations

#callbacks
  before_create :set_position
#other_logic
private
  #callback_methods
  def set_position
    self.position = (global_menu_item.sub_menu_items.by_position.try(:last).try(:position) || 0) + 1
  end

end
