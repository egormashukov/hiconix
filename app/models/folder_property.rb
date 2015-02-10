# == Schema Information
#
# Table name: folder_properties
#
#  id          :integer          not null, primary key
#  folder_id   :integer          not null
#  property_id :integer          not null
#  position    :integer
#  visible     :boolean          default(FALSE)
#  widget      :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class FolderProperty < ActiveRecord::Base
  belongs_to :folder
  belongs_to :property
end
