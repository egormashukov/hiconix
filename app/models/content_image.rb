# == Schema Information
#
# Table name: content_images
#
#  id         :integer          not null, primary key
#  image      :string(255)
#  title      :string(255)
#  content_id :integer
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#

class ContentImage < ActiveRecord::Base

#uploaders
  mount_uploader :image, ContentImagesUploader
#friendly_id
#instances
#attrs
#associations
  belongs_to :content
#scopes
#validations
#callbacks
  before_create :set_position
  skip_callback :commit, :after, :remove_image!
  skip_callback :save, :after, :remove_previously_stored_image
#other_logic

  def self.sort(content_images)
    content_images.each_with_index{|id, idx| ContentImage.find(id).update(position: idx)}
  end

private
#callback_methods

  def set_position
    self.position = (content.content_images.by_position.try(:last).try(:position) || 0) + 1
  end
#validation_methods

end
