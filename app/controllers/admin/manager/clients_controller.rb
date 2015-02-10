class Admin::Manager::ClientsController < Admin::Manager::ApplicationController
  before_action :authorize_user

  def change_managers
    params[:managers_ids].each do |client_id,manager_id|
      Client.update(client_id, {manager_id: manager_id})
    end
    redirect_to :back
  end

  def index
    load_clients
  end

  def new
    build_client
  end

  def show
    build_client
  end

  def create
    build_client
    save_client || render(:new)
  end

  def edit
    load_client
    build_client
  end

  def update
    load_client
    build_client
    save_client || render(:edit)
  end

  def destroy
    load_client
    @client.destroy
    redirect_to [:admin, :manager, :clients]
  end

private

  def load_clients
    @clients ||= client_scope.to_a
  end

  def load_client
    @client ||= client_scope.find(params[:id])
  end

  def client_scope
    Client.alphabetical
  end

  def build_client
    @client ||= client_scope.build
    @client.attributes = client_params
  end

  def save_client
    apply_redirect if @client.save
  end

  def apply_redirect(notice = '')
    if params[:apply].present?
      redirect_to [:edit, :admin, :manager, @client], notice: notice
    else
      redirect_to [:admin, :manager, :clients], notice: notice
    end
  end

  def client_params
    return {} if params[:client].blank?
    params.require(:client).permit(:first_name, :patronymic_name, :family_name, :company_title, :phone, :email,
                                   :contacts, :comment, :code_1c, :manager_id, :managers_ids)
  end
end
