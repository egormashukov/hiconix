# == Schema Information
#
# Table name: tenants
#
#  id                :integer          not null, primary key
#  title             :string(255)
#  url_scope         :string(255)
#  domain            :string(255)
#  local_nav_item_id :integer
#  created_at        :datetime
#  updated_at        :datetime
#  type              :string(255)
#  domains           :text
#

class Tenant < ActiveRecord::Base
  # attr_accessible :title, :url_scope, :local_nav_item_id
  # cattr_accessor :current_id
  has_many :brands
  belongs_to :local_nav_item

  validates :title, uniqueness: true

  serialize :domains

  def self.current_id=(id)
    Thread.current[:tenant_id] = id
  end

  def self.current_id
    Thread.current[:tenant_id]
  end

  # def self.current_domain
  #   self.find(self.current_id).domain
  # end

  # def current_domain
  #   local_nav_item.try(:url)
  # end

  def hiconix_code
    "tenant_#{id}"
  end

end
