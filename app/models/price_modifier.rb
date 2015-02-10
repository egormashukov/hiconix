# == Schema Information
#
# Table name: price_modifiers
#
#  id          :integer          not null, primary key
#  geo_set_id  :integer
#  category_id :integer
#  value       :float            default(0.0)
#  created_at  :datetime
#  updated_at  :datetime
#

class PriceModifier < ActiveRecord::Base
  default_scope {order :geo_set_id}

  belongs_to :geo_set
  belongs_to :category

  validates :value, presence: true
end
