class Admin::NewsItemsController < Admin::ApplicationController
  before_action :set_news_item, only: [:edit, :update, :destroy]
  before_action :authorize_news_item#, except: [:index]
  helper_method :apply_redirect

  def sort
    NewsItem.sort(params[:news_item])
    render :nothing => true
  end

  def index
    @news_items = policy_scope(NewsItem).order(:position)
  end

  def new
    @news_item = NewsItem.new
  end

  def create
    @news_item = NewsItem.new(news_item_params)
    if @news_item.save
      notice = "#{NewsItem.model_name.human} #{t 'flash.notice.was_added'}"
      apply_redirect(notice)
    else
      render action: 'new'
    end
  end

  def edit
  end

  def update
    if @news_item.update(news_item_params)
      notice = "#{NewsItem.model_name.human} #{t 'flash.notice.was_updated'}"
      apply_redirect(notice)
    else
      render action: 'edit'
    end
  end

  def destroy
    @news_item.destroy
    redirect_to [:admin, :news_items], notice: "#{NewsItem.model_name.human} #{t 'flash.notice.was_deleted'}"
  end

  private
    def apply_redirect(notice)
      if params[:apply].presence
        redirect_to [:edit, :admin, @news_item], notice: notice
      else
        redirect_to [:admin, :news_items], notice: notice
      end
    end

    def authorize_news_item
      authorize :news_item, :user_has_rights?
    end

    def set_news_item
      @news_item = NewsItem.find(params[:id])
    end

    def news_item_params
      params.require(:news_item).permit(:title, :caption, :type, :position, :parent_id, :page_id, :url)
    end
end