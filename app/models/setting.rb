# == Schema Information
#
# Table name: settings
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  value       :string(255)
#  description :string(255)
#  tenant_id   :integer
#  created_at  :datetime
#  updated_at  :datetime
#  hic_app     :string(255)
#

class Setting < ActiveRecord::Base
#uploaders
#friendly_id
#instances
#attrs
#associations
#scopes
#validations
  #validates_presence_of :title
#callbacks
#other_logic
private
#callback_methods
#validation_methods

end
