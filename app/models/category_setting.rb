# == Schema Information
#
# Table name: category_settings
#
#  id                    :integer          not null, primary key
#  low_category_id       :integer
#  low_level_category_id :integer
#  visible               :boolean          default(FALSE)
#  show_mode             :boolean          default(TRUE)
#  profile_id            :integer
#  title_visible         :boolean          default(TRUE)
#  position              :integer
#  tenant_id             :integer
#  created_at            :datetime
#  updated_at            :datetime
#  prefix                :string(255)
#  set_profile_id        :integer
#

class CategorySetting < ActiveRecord::Base
  default_scope {where tenant_id: Tenant.current_id if Tenant.current_id}

  # has_paper_trail
  # attr_accessible :low_category_id, :low_level_category_id, :show_mode, :visible, :title_visible, :profile_id, :horizontal_properties, :position, :prefix

  belongs_to :low_category
  belongs_to :low_level_category
  belongs_to :profile

  validates :low_category_id, presence: true
  # there is field called visible...
  # scope :visible, where(visible: true)

  # def title_for_find_and_replace
  #   "#{self.category.title} (#{self.low_level_category.title})"
  # end
end
