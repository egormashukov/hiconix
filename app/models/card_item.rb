# == Schema Information
#
# Table name: card_items
#
#  id             :integer          not null, primary key
#  card_id        :integer
#  product_id     :integer
#  product_set_id :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class CardItem < ActiveRecord::Base
end
