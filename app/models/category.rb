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

class Category < ActiveRecord::Base
  has_ancestry orphan_strategy: :rootify
  has_many :low_category_images, as: :imageable
end
