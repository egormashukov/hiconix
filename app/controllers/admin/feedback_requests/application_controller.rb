class Admin::FeedbackRequests::ApplicationController < Admin::ApplicationController
  skip_before_filter :current_tenant
  skip_around_filter :scope_current_tenant

  # skip_after_action :verify_authorized

  def default_url_options(options = {})
    {}
  end

  def authorize_user
    authorize :user, :user_has_rights?
  end
end
