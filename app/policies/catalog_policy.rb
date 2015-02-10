class CatalogPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope if user_has_rights?
      scope.none
    end

    def user_has_rights?
      return false if user.authorization_profile_policies.blank?
    (user.authorization_profile_policies & %W(CatalogBrandPolicy CatalogTypeCategoryPolicy CatalogLowCategoryPolicy CatalogFilterPolicy)).any?
    end
  end

  def user_has_rights?
    return false if user.authorization_profile_policies.blank?
    (user.authorization_profile_policies & %W(CatalogBrandPolicy CatalogTypeCategoryPolicy CatalogLowCategoryPolicy CatalogFilterPolicy)).any?
  end
end


# * [Глобальные] Меню
# ** если включён, то даёт полный доступ к разделу
# ** если выключен, то скрывает раздел и не даёт к нему доступа