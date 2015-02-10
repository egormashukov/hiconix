class SettingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope if user_has_rights?
      scope.none
    end

    def user_has_rights?
      user.authorization_profile_policies.try(:include?, "VizitkaSettingPolicy")
    end
  end

  def user_has_rights?#(tenant = current_tenant)
    #prefix = tenant.url_scope.camelize
    user.authorization_profile_policies.try(:include?, "VizitkaSettingPolicy")
  end
end

# * [Глобальные] Управление пользователями
# ** Тут собираем Элементы Управления (далее ЭУ) в профили
# ** И назначаем профили пользователям
# ** Которых задаём тут же
# *** Назначая им имя пользователя в виде email'а
# *** И пароль
# ** Этот ЭУ доступен только пользователю admin@hiconix.ru
