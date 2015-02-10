# == Schema Information
#
# Table name: brand_links
#
#  id          :integer          not null, primary key
#  brand_id    :integer
#  position    :integer
#  visible     :boolean
#  link        :string(255)
#  image       :string(255)
#  slide_image :string(255)
#  slide_body  :text
#  tenant_id   :integer
#  created_at  :datetime
#  updated_at  :datetime
#  icon_hover  :string(255)
#  title       :string(255)
#

class BrandLink < ActiveRecord::Base

  include Tenantable
#uploaders
  mount_uploader :image, BrandLinksUploader
  mount_uploader :icon_hover, BrandLinksUploader
  mount_uploader :slide_image, SmartSlidesUploader
#friendly_id
#friendly_id

#instances
#attrs
#associations
  belongs_to :brand
#scopes
#validations
  #validates_presence_of :image
#callbacks
  before_create :set_position
#other_logic
  def self.sort(brand_links)
    brand_links.each_with_index{|id, idx| BrandLink.find(id).update(position: idx)}
  end
private
#callback_methods
  def set_position
    self.position = (BrandLink.by_position.try(:last).try(:position) || 0) + 1
  end
#validation_methods
end
