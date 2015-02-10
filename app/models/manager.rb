class Manager < ActiveRecord::Base
  belongs_to :vice_manager, class_name: 'Manager'
  has_many :main_managers, foreign_key: :vice_manager_id#, class_name: 'Manager'
  has_many :clients

  scope :alphabetical, -> {order('family_name, first_name, patronymic_name')}

  def full_person_name
    "#{family_name} #{first_name}"
  end

  class << self
    def has_not_that_manager(manager_id)
      where.not(id: manager_id).map {|m| [m.full_person_name, m.id]}
    end
  end
end
