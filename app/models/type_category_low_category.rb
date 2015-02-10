# == Schema Information
#
# Table name: type_category_low_categories
#
#  id               :integer          not null, primary key
#  low_category_id  :integer          not null
#  type_category_id :integer          not null
#

class TypeCategoryLowCategory < ActiveRecord::Base
  belongs_to :low_category
  belongs_to :type_category
end
