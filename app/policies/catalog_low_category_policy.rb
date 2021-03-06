class CatalogLowCategoryPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope if user_has_rights?
      scope.none
    end

    def user_has_rights?
      user.authorization_profile_policies.try(:include?, 'CatalogLowCategoryPolicy')
    end
  end

  def user_has_rights?
    user.authorization_profile_policies.try(:include?, 'CatalogLowCategoryPolicy')
  end
end


# * [Глобальные] Меню
# ** если включён, то даёт полный доступ к разделу
# ** если выключен, то скрывает раздел и не даёт к нему доступа