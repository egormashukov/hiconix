# == Schema Information
#
# Table name: profiles
#
#  id                    :integer          not null, primary key
#  title                 :string(255)
#  horizontal_properties :boolean          default(FALSE)
#  font                  :integer          default(3)
#  zebra                 :boolean          default(TRUE)
#  highlight             :boolean          default(TRUE)
#  link_fill_row         :boolean          default(TRUE)
#  show_desc             :boolean          default(TRUE)
#  units_in_cell         :boolean          default(FALSE)
#  tenant_id             :integer
#  created_at            :datetime
#  updated_at            :datetime
#  products_count        :integer          default(0), not null
#  hic_app               :string(255)
#

class Profile < ActiveRecord::Base

end
