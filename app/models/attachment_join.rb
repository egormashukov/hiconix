# == Schema Information
#
# Table name: attachment_joins
#
#  id                  :integer          not null, primary key
#  attachmentable_type :string(255)
#  attachmentable_id   :integer
#  position            :integer
#  visible             :boolean
#  attachment_id       :integer
#  created_at          :datetime
#  updated_at          :datetime
#

class AttachmentJoin < ActiveRecord::Base
  default_scope { order('position')}
  belongs_to :attachmentable, polymorphic: true
  belongs_to :attachment

  validates :attachment_id, presence: true
end
