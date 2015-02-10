class Admin::Aux::ApplicationController < Admin::ApplicationController
  skip_before_filter :current_tenant
  skip_around_filter :scope_current_tenant
  before_filter :check_aux_brand

  # skip_after_action :verify_authorized

  def default_url_options(options = {})
    {}
  end

  private

  def check_aux_brand
    redirect_to admin_root_path unless CatalogueBrandLink.aux_brand_link.present?
  end
end
