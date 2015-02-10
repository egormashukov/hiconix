class Admin::Administrator::ManagersController < Admin::Manager::ApplicationController
  before_action :authorize_user

  def sort
    Manager.sort(params[:manager])
    render nothing: true
  end

  def index
    load_managers
  end

  def new
    build_manager
  end

  def show
    build_manager
  end

  def create
    build_manager
    save_manager || render(:new)
  end

  def edit
    load_manager
    build_manager
  end

  def update
    load_manager
    build_manager
    save_manager || render(:edit)
  end

  def destroy
    load_manager
    @manager.destroy
    redirect_to [:admin, :administrator, :managers]
  end

private

  def load_managers
    @managers ||= manager_scope.to_a
  end

  def load_manager
    @manager ||= manager_scope.find(params[:id])
  end

  def manager_scope
    ::Manager.alphabetical
  end

  def build_manager
    @manager ||= manager_scope.build
    @manager.attributes = manager_params
  end

  def save_manager
    apply_redirect if @manager.save
  end

  def apply_redirect(notice = '')
    if params[:apply].present?
      redirect_to [:edit, :admin, :administrator, @manager], notice: notice
    else
      redirect_to [:admin, :administrator, :managers], notice: notice
    end
  end

  def authorize_user
    authorize :user, :user_has_rights?
  end

  def manager_params
    return {} if params[:manager].blank?
    params.require(:manager).permit(:first_name, :patronymic_name, :family_name, :vice_mananger_id, :on_duty)
  end
end
