class Admin::FeedbackRequests::ClientMailsController < Admin::FeedbackRequests::ApplicationController
  before_action :authorize_user

  def create
    render text: 'ok'
  end
end
