# == Schema Information
#
# Table name: smart_slides
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  position   :integer
#  visible    :boolean
#  image      :string(255)
#  link       :string(255)
#  body       :text
#  tenant_id  :integer
#  created_at :datetime
#  updated_at :datetime
#  icon       :string(255)
#

class SmartSlide < ActiveRecord::Base

  include Tenantable
#uploaders
  mount_uploader :image, SmartSlidesUploader
  mount_uploader :icon, SliderIconUploader
#friendly_id
#instances
#attrs
#associations
#scopes
#validations
  #validates_presence_of :image
#callbacks
  before_create :set_position
#other_logic
  def self.sort(smart_slides)
    smart_slides.each_with_index{|id, idx| SmartSlide.find(id).update(position: idx)}
  end
private
#callback_methods
  def set_position
    self.position = (SmartSlide.by_position.try(:last).try(:position) || 0) + 1
  end
#validation_methods
end
