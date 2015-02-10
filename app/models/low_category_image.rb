# == Schema Information
#
# Table name: product_images
#
#  id             :integer          not null, primary key
#  image          :string(255)
#  position       :integer
#  visible        :boolean          default(TRUE)
#  tenant_id      :integer
#  created_at     :datetime
#  updated_at     :datetime
#  imageable_type :string(255)
#  imageable_id   :integer
#

class LowCategoryImage < ActiveRecord::Base
  self.table_name = 'product_images'
  default_scope { order('position') }

  mount_uploader :image, LowCategoriesUploader
  skip_callback :commit, :after, :remove_image!
  skip_callback :save, :after, :remove_previously_stored_image

  belongs_to :imageable, polymorphic: true
  before_create :add_position

private

  def add_position
    self.position = (imageable.low_category_images.order('position').last.try(:position) || 0) + 1
  end

  def self.sort(categories)
    categories.each_with_index{|id, idx| find(id).update(position: idx)}
  end
end
