module Tenantable
  extend ActiveSupport::Concern

  included do
    default_scope -> { where tenant_id: Tenant.current_id if Tenant.current_id }

    scope :with_tenant_constraint, -> { where tenant_id: Tenant.current_id if Tenant.current_id }
  end

  # module ClassMethods
  # end
end