# encoding: utf-8
# == Schema Information
#
# Table name: properties
#
#  id               :integer          not null, primary key
#  title            :string(255)
#  measurement_unit :string(255)
#  hiconix_code     :string(255)
#  type             :string(255)
#  description      :text
#  desc_url         :string(255)
#  dynamic_string   :text             default("")
#  seo              :string(255)
#  tenant_id        :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class Property < ActiveRecord::Base
  default_scope {where tenant_id: Tenant.current_id if Tenant.current_id}

  DIMENSIONAL_UNITS = {
    'Мощность' => %w{кВт Вт BTU/час},
    'Расход' => ['м3/ч'],
    'Масса' => %w{т кг г},
    'Длина' => %w{км м см мм дюйм мкм},
    'Крутящий момент' => %w{Нм},
    'Объем' => %w{м³ см³ мм³ л},
    'Площадь' => %w{м² см² мм²},
    'Плотность' => %w{кг/м³ г/см³},
    'Скорость' => %w{м/с},
    'Температура' => %w{°C},
    'Давление' => %w{кПа Па торр bar},
    'Сила тока' => %w{А мА},
    'Напряжение' => %w{В},
    'Время' => %w{с мин час день год},
    'Сила' => %w{Н},
    'Частота вращения' => %w{об/мин},
    'Частота' => %w{Гц кГц},
    'Влажность' => %w{%RH}
  }

  MONETARY_TITLE = 'Валюта'
  MONETARY_UNITS = ['USD', 'EUR', 'руб']
  DIMENSIONLESS_UNITS = ['дБ(А)', '']

  UNITS_ARRAY = MONETARY_UNITS + DIMENSIONLESS_UNITS + DIMENSIONAL_UNITS.values.flatten
  ALL_DIMENSIONAL = DIMENSIONAL_UNITS.merge({MONETARY_TITLE: MONETARY_UNITS})

  validates :title, presence: true, uniqueness: {scope: [:tenant_id]}

  scope :not_dynamic, -> { where(type: nil) }
  scope :dynamic, -> { where(type: 'DynamicProperty') }

  def editable_measurement_unit?
    !UNITS_ARRAY.include?(self.measurement_unit) && !price?
  end

  def price?
    measurement_unit == MONETARY_TITLE
  end

  def dimensional_units_for_curr_filter
    ALL_DIMENSIONAL.values.map {|array| return array if array.include?(measurement_unit)} || []
  end

  class << self

    def properties_for_select
      not_dynamic.order(:title).map{|p| [p.title, p.id]}
    end
  end
end
