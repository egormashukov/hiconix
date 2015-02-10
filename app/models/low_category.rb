# == Schema Information
#
# Table name: categories
#
#  id                   :integer          not null, primary key
#  title                :string(255)
#  brand_id             :integer
#  folder_id            :integer
#  description          :text
#  teaser_desc          :text
#  image                :string(255)
#  slug                 :string(255)
#  ancestry             :string(255)
#  visible              :boolean
#  position             :integer
#  table_mode           :boolean          default(TRUE)
#  child_desc_mode      :boolean          default(TRUE)
#  file_mode            :boolean          default(FALSE)
#  h_code               :string(255)
#  tree                 :string(255)      default("brand")
#  tenant_id            :integer
#  created_at           :datetime
#  updated_at           :datetime
#  menu_title           :string(255)
#  hic_app              :string(255)
#  catalog_category_id  :integer
#  table_set_profile_id :integer
#

class LowCategory < Category
  has_ancestry orphan_strategy: :rootify

  has_many :type_category_low_categories
  has_many :type_categories, through: :type_category_low_categories

  has_many :category_settings
  has_many :low_category_images, as: :imageable

  belongs_to :common_low_category, foreign_key: :common_category_id, class_name: 'LowCategory'

  has_many :attachment_joins, as: :attachmentable, dependent: :destroy
  has_many :attachments, through: :attachment_joins

  belongs_to :tenant
  belongs_to :folder

  accepts_nested_attributes_for :category_settings

  mount_uploader :image, LowCategoriesUploader

  validate :title, :tenant_id, presence: true

  after_create :create_category_settings

  scope :without_common_category, -> { where(common_category_id: nil) }
  scope :with_tenant, -> { where.not(tenant_id: nil) }
  scope :belongs_to_folder_with_properties, -> { joins(folder: :folder_properties).uniq }

  def nested_low_categories
    LowCategory.where(common_category_id: self.id)
  end

  def self.has_not_this_low_category(low_category)
    where.not(common_category_id: low_category.id)
  end

  def is_common_low_category?
    common_category_id.nil?
  end

  def create_category_settings
    category_settings = []
    LowLevelCategory.all.each do |llc|
      category_settings << {low_category_id: self.id, low_level_category_id: llc.id, tenant_id: Tenant.current_id}
    end
    CategorySetting.create(category_settings)
  end

private

  def self.sort(categories)
    categories.each_with_index{|id, idx| find(id).update(position: idx)}
  end
end
