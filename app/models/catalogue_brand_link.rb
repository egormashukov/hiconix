# == Schema Information
#
# Table name: catalogue_brand_links
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :text
#  teaser_desc :text
#  brand_id    :integer          not null
#  position    :integer
#  visible     :boolean
#  tenant_id   :integer          not null
#  created_at  :datetime
#  updated_at  :datetime
#  image       :string(255)
#  hover_image :string(255)
#  slug        :string(255)
#

class CatalogueBrandLink < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title_with_russian, use: :slugged

  belongs_to :brand
  belongs_to :type_category

  has_many :low_categories, foreign_key: :brand_id

  has_many :catalogue_brand_link_type_categories, dependent: :destroy
  has_many :type_categories, through: :catalogue_brand_link_type_categories

  has_many :attachment_joins, as: :attachmentable
  has_many :attachments, through: :attachment_joins

  scope :in_current_tenant, -> { where tenant_id: Tenant.current_id if Tenant.current_id }

  validates :brand_id, :tenant_id, presence: true

  has_not_this :type_category, through: :catalogue_brand_link_type_categories, order: :title, by: :title

  class << self
    def sort(brands)
      brands.each_with_index{|id, idx| find(id).update(position: idx)}
    end

    def aux_brand_link
      Brand.aux_brand.catalogue_brand_links.try(:first)
    end

    def aux_brand_exists?
      aux_brand_link
    end
  end

private

  def title_with_russian
    "#{Russian.translit(title)}"
  end
end
