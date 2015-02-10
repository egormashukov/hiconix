# == Schema Information
#
# Table name: type_categories
#
#  id          :integer          not null, primary key
#  title       :string(255)      not null
#  slug        :string(255)
#  position    :integer
#  visible     :boolean
#  tenant_id   :integer          not null
#  created_at  :datetime
#  updated_at  :datetime
#  grouping    :string(255)
#  description :text
#  teaser_desc :text
#

class TypeCategory < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title_with_russian, use: :slugged

  has_many :type_category_catalogue_brand_links, dependent: :destroy
  has_many :catalogue_brand_links, through: :type_category_catalogue_brand_links

  has_many :type_category_low_categories, dependent: :destroy
  has_many :low_categories, through: :type_category_low_categories

  has_not_this :catalogue_brand_link, through: :catalogue_brand_link_type_categories, order: :title, by: :title
  has_not_this :low_category, through: :type_category_low_category, order: :title, by: :title

  validate :title, :tenant_id, presence: true

  def self.sort(categories)
    categories.each_with_index{|id, idx| find(id).update(position: idx)}
  end

private

  def title_with_russian
    "#{Russian.translit(title)}"
  end
end
