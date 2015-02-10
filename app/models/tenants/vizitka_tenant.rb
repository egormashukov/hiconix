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

class VizitkaTenant < Tenant

  [:vizitka, :opt, :parts, :service].each do |key|
    define_singleton_method key do
      where(url_scope: key.to_s).first
    end
  end

end
