class Admin::FeedbackRequests::ClientCallsController < Admin::FeedbackRequests::ApplicationController
  before_action :authorize_user

  def create
    render text: Jabber.new(params[:contact_data]).ring
  end
end
