# == Schema Information
#
# Table name: authorization_profiles
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  policies   :string(255)      default([])
#  created_at :datetime
#  updated_at :datetime
#

class AuthorizationProfile < ActiveRecord::Base

  has_many :users

  def self.for_select
    pluck(:title, :id)
  end

  def self.policies_for_select
    [
      ['Управление пользователями', 'UserPolicy'],
      ['[Глобальные] Меню', 'GlobalMenuItemPolicy'],
      ['[Визитка] Страницы', 'VizitkaPagePolicy'],
      ['[Визитка] Блоки', 'VizitkaBlockPolicy'],
      ['[Визитка] Слайдеры', 'VizitkaSliderItemPolicy'],
      ['[Визитка] Бренды', 'VizitkaBrandLinkPolicy'],
      ['[Визитка] Ссылко-каталог виджет', 'VizitkaCategoryMenuItemPolicy'],
      ['[Визитка] Новости', 'VizitkaNewsItemPolicy'],
      ['[Визитка] Настройки', 'VizitkaSettingPolicy'],
      ['[Опт] Страницы', 'OptPagePolicy'],
      ['[Опт] Блоки', 'OptBlockPolicy'],
      ['[Запчасти] Страницы', 'PartsPagePolicy'],
      ['[Запчасти] Блоки', 'PartsBlockPolicy'],
      ['[Сервис] Страницы', 'ServicePagePolicy'],
      ['[Сервис] Блоки', 'ServiceBlockPolicy'],
      ['[Каталоги] Бренды', 'CatalogBrandPolicy'],
      ['[Каталоги] Типы категорий', 'CatalogTypeCategoryPolicy'],
      ['[Каталоги] Категории нижнего уровня', 'CatalogLowCategoryPolicy'],
      ['[Каталоги] Фильтры', 'CatalogFilterPolicy']
    ]
  end
end
