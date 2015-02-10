class Admin::BslideMenuItemsController < Admin::ApplicationController
  before_action :set_bslide_menu_item, only: [:edit, :update, :destroy ]
  before_action :authorize_slider_item
  helper_method :apply_redirect

  def sort
    BslideMenuItem.sort(params[:bslide_menu_item])
    render :nothing => true
  end

  def index
    @bslide_menu_items = BslideMenuItem.order(:position)
  end

  def new
    @bslide_menu_item = BslideMenuItem.new
  end

  def create
    @bslide_menu_item = BslideMenuItem.new(bslide_menu_item_params)
    if @bslide_menu_item.save
      notice = "#{BslideMenuItem.model_name.human} #{t 'flash.notice.was_added'}"
      apply_redirect(notice)
    else
      render action: 'new'
    end
  end

  def edit
  end

  def update
    if @bslide_menu_item.update(bslide_menu_item_params)
      notice = "#{BslideMenuItem.model_name.human} #{t 'flash.notice.was_updated'}"
      apply_redirect(notice)
    else
      render action: 'edit'
    end
  end

  def destroy
    @bslide_menu_item.destroy
    redirect_to [:admin, :bslide_menu_items], notice: "#{BslideMenuItem.model_name.human} #{t 'flash.notice.was_deleted'}"
  end

  private
    def apply_redirect(notice)
      if params[:apply].presence
        redirect_to [:edit, :admin, @bslide_menu_item], notice: notice
      else
        redirect_to [:admin, :bslide_menu_items], notice: notice
      end
    end

    def authorize_slider_item
      authorize :slider_item, :user_has_rights?
    end

    def set_bslide_menu_item
      @bslide_menu_item = BslideMenuItem.find(params[:id])
    end

    def bslide_menu_item_params
      params.require(:bslide_menu_item).permit(:title, :caption, :type, :position, :parent_id, :page_id, :url)
    end
end