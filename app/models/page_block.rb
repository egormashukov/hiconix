# encoding: utf-8
# == Schema Information
#
# Table name: page_blocks
#
#  id                 :integer          not null, primary key
#  page_id            :integer
#  block_id           :integer
#  teaser_modificator :boolean          default(FALSE)
#  sort_modificator   :boolean          default(FALSE)
#  position           :integer
#  visible            :boolean          default(FALSE)
#  social_modificator :boolean          default(FALSE)
#  canonical          :boolean          default(FALSE)
#  tenant_id          :integer
#  created_at         :datetime
#  updated_at         :datetime
#  list_style         :string(255)      default("three_items")
#

class PageBlock < ActiveRecord::Base

  include Tenantable
#uploaders
#friendly_id
#instances
#attrs
#associations
  belongs_to :page
  belongs_to :block
#scopes
#validations
  validates :page_id, :block_id, presence: true
#callbacks

  before_create :set_position

#other_logic

  def self.list_style_options_for_select
    [['один пункт','one_item'],
      ['несколько пунктов', 'three_items'],
      ['вертикальный стиль', 'vertical']]
  end

  def self.sort(page_block)
    page_block.each_with_index{|id, idx| PageBlock.find(id).update(position: idx)}
  end

private
#callback_methods

  def set_position
    self.position = (page.page_blocks.by_position.try(:last).try(:position) || 0) + 1
  end

#validation_methods
end
