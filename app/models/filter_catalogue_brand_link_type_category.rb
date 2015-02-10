# == Schema Information
#
# Table name: filter_catalogue_brand_link_type_categories
#
#  id                                    :integer          not null, primary key
#  filter_id                             :integer          not null
#  catalogue_brand_link_type_category_id :integer          not null
#  position                              :integer
#  visible                               :boolean          default(FALSE)
#  created_at                            :datetime
#  updated_at                            :datetime
#

class FilterCatalogueBrandLinkTypeCategory < ActiveRecord::Base
  belongs_to :filter
  belongs_to :catalogue_brand_link_type_category

  validates :filter_id, :catalogue_brand_link_type_category_id, presence: true

  scope :by_brand_and_category, -> (id) {where(catalogue_brand_link_type_category_id: id)}

  def self.filters_axists?(id)
    by_brand_and_category(id).present? ? 'ecть фильтры' : 'нет'
  end

  def self.sort(filters)
    filters.each_with_index{|id, idx| find(id).update(position: idx)}
  end
end
