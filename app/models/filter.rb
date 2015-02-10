# == Schema Information
#
# Table name: filters
#
#  id                :integer          not null, primary key
#  title             :string(255)
#  property_id       :integer          not null
#  widget            :string(255)
#  measurement_units :text
#  position          :integer
#  tenant_id         :integer          not null
#  created_at        :datetime
#  updated_at        :datetime
#

class Filter < ActiveRecord::Base
  default_scope {where tenant_id: Tenant.current_id if Tenant.current_id}

  has_many :filter_catalogue_brand_link_type_categories, dependent: :destroy
  has_many :catalogue_brand_link_type_categories, through: :filter_catalogue_brand_link_type_categories

  belongs_to :property

  has_not_that :catalogue_brand_link_type_category, through: :filter_catalogue_brand_link_type_categories

  serialize :measurement_units

  DIMENSIONAL_WIDGETS = %w{slider slider_range}
  NOT_DIMENSIONAL_WIDGETS = %w{checkbox radio selector multiselector}

  validates :title, presence: true
  validates :widget, presence: true, on: :update

  def self.sort(filters)
    filters.each_with_index{|id, idx| find(id).update(position: idx)}
  end
end
