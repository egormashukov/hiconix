# == Schema Information
#
# Table name: category_menu_items
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  url        :string(255)
#  ancestry   :string(255)
#  position   :integer
#  visible    :boolean
#  created_at :datetime
#  updated_at :datetime
#  tenant_id  :integer
#

class CategoryMenuItem < ActiveRecord::Base
  include Tenantable
#uploaders
#friendly_id
#instances
#attrs
#associations
  has_ancestry :orphan_strategy => :rootify
#scopes
#validations
  #validates_presence_of :title
#callbacks
  before_create :set_position
#other_logic
  def self.sort(list)

    temp = {}
    list.each do |key, value|
      if temp[value]
        temp[value] << key
      else
        temp[value] = [key]
      end
    end

    temp.each do |parent, cats|
      i = 1
      if parent == 'root' || parent == 'null'
        p = ''
      else
        p = CategoryMenuItem.find(parent).id
      end
      cats.each do |cat|
        c = CategoryMenuItem.find(cat)
        c.parent_id = p
        c.position = i
        c.save
        i += 1
      end
    end
  end
  
private
#callback_methods
  def set_position
    self.position = (CategoryMenuItem.by_position.try(:last).try(:position) || 0) + 1
  end
#validation_methods
end
