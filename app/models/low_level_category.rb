# == Schema Information
#
# Table name: low_level_categories
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  slug       :string(255)
#  tenant_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class LowLevelCategory < ActiveRecord::Base
  default_scope {where tenant_id: Tenant.current_id if Tenant.current_id}
end
