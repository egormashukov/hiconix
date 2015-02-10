# == Schema Information
#
# Table name: attachments
#
#  id                        :integer          not null, primary key
#  source                    :string(255)
#  title                     :string(255)
#  comment                   :text
#  hiconix_code              :string(255)
#  tenant_id                 :integer
#  created_at                :datetime
#  updated_at                :datetime
#  product_attachments_count :integer          default(0), not null
#  file_extension            :string(255)
#  file_size                 :string(255)
#  preview                   :string(255)
#  source_processing         :boolean          default(FALSE), not null
#  source_tmp                :string(255)
#

class Attachment < ActiveRecord::Base
  mount_uploader :source, AttachmentUploader

  belongs_to :attachmentable, polymorphic: true
  has_many :attachment_joins
  has_many :low_categories, foreign_key: :attachment_id, through: :attachment_joins, source: :attachmentable#, source_type: 'Category'

  has_not_that :attachmentable, through: :attachment_joins

  validates :source, presence: true
end
