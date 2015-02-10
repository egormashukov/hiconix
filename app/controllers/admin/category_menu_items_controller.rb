class Admin::CategoryMenuItemsController < Admin::ApplicationController
  before_action :set_category_menu_item, only: [:edit, :update, :destroy, :togglevisible]
  before_action :authorize_category_menu_item#, except: [:index]
  helper_method :apply_redirect

  def togglevisible
    @category_menu_item.toggle(:visible)
    @category_menu_item.save
  end

  def change_visible
    val = params[:invisible].presence ? false : true
    CategoryMenuItem.update_all({visible: val}, {id: params[:category_menu_item_ids]})
    redirect_to :back
  end

  def sort
    CategoryMenuItem.sort(params[:list])
    render :nothing => true
  end

  def index
    @category_menu_items = policy_scope(CategoryMenuItem).order(:position)
  end

  def new
    @category_menu_item = CategoryMenuItem.new
  end

  def create
    @category_menu_item = CategoryMenuItem.new(category_menu_item_params)
    if @category_menu_item.save
      notice = "#{CategoryMenuItem.model_name.human} #{t 'flash.notice.was_added'}"
      apply_redirect(notice)
    else
      render action: 'new'
    end
  end

  def edit
  end

  def update
    if @category_menu_item.update(category_menu_item_params)
      notice = "#{CategoryMenuItem.model_name.human} #{t 'flash.notice.was_updated'}"
      apply_redirect(notice)
    else
      render action: 'edit'
    end
  end

  def destroy
    @category_menu_item.destroy
    redirect_to [:admin, :category_menu_items], notice: "#{CategoryMenuItem.model_name.human} #{t 'flash.notice.was_deleted'}"
  end

  private
    def apply_redirect(notice)
      if params[:apply].presence
        redirect_to [:edit, :admin, @category_menu_item], notice: notice
      else
        redirect_to [:admin, :category_menu_items], notice: notice
      end
    end

    def authorize_category_menu_item
      authorize :category_menu_item, :user_has_rights?
    end

    def set_category_menu_item
      @category_menu_item = CategoryMenuItem.find(params[:id])
    end

    def category_menu_item_params
      params.require(:category_menu_item).permit(:title, :url, :ancestry, :position, :visible)
    end
end