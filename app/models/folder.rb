# == Schema Information
#
# Table name: folders
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :text
#  slug        :string(255)
#  tenant_id   :integer
#  created_at  :datetime
#  updated_at  :datetime
#

#coding: utf-8
class Folder < ActiveRecord::Base
  # default_scope {where tenant_id: Tenant.current_id if Tenant.current_id}

  has_many :folder_properties, dependent: :destroy
  has_many :folders, through: :folder_properties

  # has_many :features, :through => :folder_features
  # has_many :folder_features
  #
  # has_many :low_categories
end
