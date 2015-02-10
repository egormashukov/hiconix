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

class NewsItem < MenuItem
#uploaders
#friendly_id
#instances
#attrs
#associations
#scopes
#validations
  validates :caption, length: { maximum: 255 }

#callbacks
  before_create :set_position
#other_logic

private
  #callback_methods
  def set_position
    self.position = (NewsItem.by_position.try(:last).try(:position) || 0) + 1
  end

end
