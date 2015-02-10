class Client < ActiveRecord::Base
  belongs_to :manager

  SHOW_INDEX_FIELDS = %w{full_person_name company_title phone email contacts comment code_1c}

  scope :alphabetical, -> {order('family_name, first_name, patronymic_name')}

  def full_person_name
    "#{family_name} #{first_name} #{patronymic_name}"
  end
end
