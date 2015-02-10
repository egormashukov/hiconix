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

class MenuItem < ActiveRecord::Base
#uploaders
#friendly_id
#instances
#attrs
#associations
#scopes
#validations
  validates :title, :url, presence: true
#callbacks
#other_logic

  def self.sort(contents)
    contents.each_with_index{|id, idx| MenuItem.find(id).update(position: idx)}
  end

private
#callback_methods


end
