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

class TypeCategoryCatalogueBrandLink < ActiveRecord::Base
  self.table_name = 'catalogue_brand_link_type_categories'
  belongs_to :type_category
  belongs_to :catalogue_brand_link
  validates :type_category_id, :catalogue_brand_link_id, presence: true
end
