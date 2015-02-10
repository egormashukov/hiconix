class Component < ActiveRecord::Base
  validates :icon, :title, :description, presence: true

end
