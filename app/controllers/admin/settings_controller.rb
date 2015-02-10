class Admin::SettingsController < Admin::ApplicationController
  before_action :set_setting, only: [:edit, :update, :destroy]
  before_action :authorize_setting#, except: [:index]
  helper_method :apply_redirect

  skip_before_filter :current_tenant
  skip_around_filter :scope_current_tenant

  def index
    @settings = policy_scope(Setting).order(:created_at)
  end

  def new
    @setting = Setting.new
    # authorize(@setting, :user_has_rights?)
  end

  def create
    @setting = Setting.new(setting_params)
    # authorize(@setting, :user_has_rights?)
    if @setting.save
      notice = "#{Setting.model_name.human} #{t 'flash.notice.was_added'}"
      apply_redirect(notice)
    else
      render action: 'new'
    end
  end

  def edit
    # authorize(@setting, :user_has_rights?)
  end

  def update
    # authorize(@setting, :user_has_rights?)
    if @setting.update(setting_params)
      notice = "#{Setting.model_name.human} #{t 'flash.notice.was_updated'}"
      apply_redirect(notice)
    else
      render action: 'edit'
    end
  end

  def destroy
    # authorize(@setting, :user_has_rights?)
    @setting.destroy
    redirect_to [:admin, :settings], notice: "#{Setting.model_name.human} #{t 'flash.notice.was_deleted'}"
  end

  private
    def apply_redirect(notice)
      if params[:apply].presence
        redirect_to [:edit, :admin, @setting], notice: notice
      else
        redirect_to [:admin, :settings], notice: notice
      end
    end

    def authorize_setting
      authorize :setting, :user_has_rights?
    end

    def set_setting
      @setting = Setting.find(params[:id])
    end

    def setting_params
      params.require(:setting).permit(:title, :value, :description, :tenant_id, :hic_app)
    end
end