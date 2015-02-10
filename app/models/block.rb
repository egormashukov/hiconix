# encoding: utf-8
# == Schema Information
#
# Table name: blocks
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  tenant_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class Block < ActiveRecord::Base

  include Tenantable
#uploaders
#friendly_id
#instances
#attrs
  attr_accessor :page_id
#associations
  has_many :pages, through: :page_blocks
  has_many :page_blocks, dependent: :destroy
  has_many :contents
#scopes
  has_not_that :page, through: :page_blocks, order: :title, by: :title
#validations
  validates :title, presence: true, uniqueness: { scope: :tenant_id }
#callbacks
  after_create :add_page_block, if: :has_page_id?

#other_logic
  def has_page_id?
    page_id.presence
  end

  def untouchable?
    ["адреса", "схемы проезда", "новости"].include?(title)
  end

private

#callback_methods
  def add_page_block
    page_blocks.create(page_id: page_id)
  end

#validation_methods
end
