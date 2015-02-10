# == Schema Information
#
# Table name: slider_items
#
#  id           :integer          not null, primary key
#  body         :text
#  slider_image :string(255)
#  page_id      :integer
#  position     :integer
#  visible      :boolean          default(FALSE)
#  title_mode   :boolean          default(FALSE)
#  geo_set_id   :integer
#  tenant_id    :integer
#  created_at   :datetime
#  updated_at   :datetime
#  hic_app      :string(255)
#

class SliderItem < ActiveRecord::Base

  include Tenantable
#uploaders
  mount_uploader :slider_image, SliderImageUploader
#instances
#attrs
#associations
  belongs_to :page
  belongs_to :geo_set
#scopes
  default_scope { with_tenant_constraint.order("position").where(hic_app: nil) }
  scope :with_no_geo, -> {includes(:geo_set).where("geo_sets.id" => nil)}
#validations
  validates :slider_image, presence: true
#callbacks
  before_create :set_position
  skip_callback :commit, :after, :remove_slider_image!
  skip_callback :save, :after, :remove_previously_stored_slider_image

#other_logic
  def self.sort(slider_items)
    slider_items.each_with_index{|id, idx| SliderItem.find(id).update(position: idx)}
  end

  private
  #callback_methods

    def set_position
      self.position = (SliderItem.by_position.try(:last).try(:position) || 0) + 1
    end
    #validation_methods

end
