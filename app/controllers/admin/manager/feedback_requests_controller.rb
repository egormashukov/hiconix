class Admin::Manager::FeedbackRequestsController < Admin::Manager::ApplicationController
  before_action :authorize_user

  def index
    load_feedback_requests
  end

  # def new
  #   build_feedback_request
  # end

  def show
    load_feedback_request
    check_request_state
  end

  # def create
  #   build_feedback_request
  #   save_feedback_request || render(:new)
  # end

  # def edit
  #   load_feedback_request
  #   build_feedback_request
  # end

  # def update
  #   load_feedback_request
  #   build_feedback_request
  #   save_feedback_request || render(:edit)
  # end

  def destroy
    load_feedback_request
    @feedback_request.destroy
    redirect_to [:admin, :manager, :feedback_requests]
  end

private

  def load_feedback_requests
    @feedback_requests ||= feedback_request_scope.to_a
  end

  def load_feedback_request
    @feedback_request ||= feedback_request_scope.find(params[:id])
  end

  def feedback_request_scope
    # TODO do .scoped
    ::FeedbackRequest.where.not id: nil
  end

  def build_feedback_request
    @feedback_request ||= feedback_request_scope.build
    @feedback_request.attributes = feedback_request_params
  end

  def save_feedback_request
    apply_redirect if @feedback_request.save
  end

  def apply_redirect(notice = '')
    # if params[:apply].present?
    #   redirect_to [:edit, :admin, :manager, @feedback_request], notice: notice
    # else
    redirect_to [:admin, :manager, :feedback_requests], notice: notice
    # end
  end

  def check_request_state
    apply_redirect(t(:request_already_read)) unless @feedback_request.new?
  end

  def feedback_request_params
    return {} if params[:feedback_request].blank?
    params.require(:feedback_request).permit()
  end
end
