# == Schema Information
#
# Table name: catalogue_brand_link_type_categories
#
#  id                                    :integer          not null, primary key
#  title                                 :string(255)
#  show_category                         :boolean
#  show_brand                            :boolean
#  catalogue_brand_link_type_category_id :integer
#  catalogue_brand_link_id               :integer          not null
#  type_category_id                      :integer          not null
#

class CatalogueBrandLinkTypeCategory < ActiveRecord::Base
  belongs_to :catalogue_brand_link
  belongs_to :type_category
  validates :catalogue_brand_link_id, :type_category_id, presence: true

  has_many :filter_catalogue_brand_link_type_categories, dependent: :destroy
  has_many :filters, through: :filter_catalogue_brand_link_type_categories

  scope :by_category, -> (id) { where(type_category_id: id) }
  scope :by_brand, -> (id) { where(catalogue_brand_link_id: id) }

  def self.current_assoc_exists?(category_id, brand_id)
    assoc = by_category(category_id).by_brand(brand_id)
    assoc.present? ? assoc.first.id : false
  end
end
