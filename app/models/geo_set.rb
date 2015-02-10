# == Schema Information
#
# Table name: geo_sets
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  reversed   :boolean          default(FALSE)
#  tenant_id  :integer
#  created_at :datetime
#  updated_at :datetime
#  hic_app    :string(255)
#

class GeoSet < ActiveRecord::Base

  include Tenantable

  has_one :slider_item
  has_many :price_modifiers, dependent: :destroy
  has_many :cities
  has_many :states
  has_many :countries

  scope :with_no_slider_items, lambda {includes(:slider_item).where("slider_items.id" => nil)}

end
