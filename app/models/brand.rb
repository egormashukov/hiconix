# == Schema Information
#
# Table name: brands
#
#  id           :integer          not null, primary key
#  title        :string(255)
#  image        :string(255)
#  slug         :string(255)
#  description  :text
#  visible      :boolean
#  position     :integer
#  teaser_desc  :text
#  created_at   :datetime
#  updated_at   :datetime
#  hover_image  :string(255)
#  select_image :string(255)
#

class Brand < ActiveRecord::Base
  has_many :brand_links, dependent: :destroy
  has_many :catalogue_brand_links, dependent: :destroy

  extend FriendlyId
  friendly_id :title_with_russian, use: :slugged

  mount_uploader :image, BrandsUploader
  mount_uploader :hover_image, BrandsUploader
  mount_uploader :select_image, BrandsUploader

  validates :title, :slug, presence: true
  validates :image, :hover_image, allow_blank: true, format: { with: %r{\A[^\s]+\.(png|jpg)\z}i }

  def title_with_russian
    Russian.translit(self.title)
  end

  class << self
    def sort(brands)
      brands.each_with_index{|id, idx| Brand.find(id).update(position: idx)}
    end

    def aux_brand
      find_by_slug('aux')
    end
  end
end
