# encoding: utf-8
class Admin::ApplicationController < ActionController::Base
  protect_from_forgery
  include Pundit

  before_filter :authenticate_user!
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_filter :current_tenant
  around_filter :scope_current_tenant
  after_action :verify_authorized, except: :index

  layout 'admin'

  def default_url_options(options = {})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { tenant_id: params[:tenant_id] || 'vizitka' }
  end

  private

  def user_not_authorized
    flash[:error] = 'У вас нет прав на осуществление данного действия.'
    redirect_to(request.referrer || admin_root_path)
  end

  def current_tenant
    Tenant.where(url_scope: params[:tenant_id] || 'vizitka').first
  end

  helper_method :current_tenant

  def scope_current_tenant
    Tenant.current_id = current_tenant.id
    yield
  ensure
    Tenant.current_id = nil
  end
end
