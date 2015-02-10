module Admin
module GlobalSettings

class GlobalMenuItemsController < Admin::GlobalSettings::ApplicationController
  before_action :set_global_menu_item, only: [:edit, :update, :destroy ]
  before_action :authorize_global_menu_item
  helper_method :apply_redirect

  skip_before_filter :current_tenant
  skip_around_filter :scope_current_tenant

  def sort
    GlobalMenuItem.sort(params[:global_menu_item])
    render :nothing => true
  end

  def index
    @global_menu_items = policy_scope(GlobalMenuItem).order(:position)
  end

  def new
    @global_menu_item = GlobalMenuItem.new
  end

  def create
    @global_menu_item = GlobalMenuItem.new(global_menu_item_params)
    if @global_menu_item.save
      notice = "#{GlobalMenuItem.model_name.human} #{t 'flash.notice.was_added'}"
      apply_redirect(notice)
    else
      render action: 'new'
    end
  end

  def edit
    @sub_menu_items = @global_menu_item.sub_menu_items.by_position
  end

  def update
    if @global_menu_item.update(global_menu_item_params)
      notice = "#{GlobalMenuItem.model_name.human} #{t 'flash.notice.was_updated'}"
      apply_redirect(notice)
    else
      render action: 'edit'
    end
  end

  def destroy
    @global_menu_item.destroy
    redirect_to [:admin, :global_menu_items], notice: "#{GlobalMenuItem.model_name.human} #{t 'flash.notice.was_deleted'}"
  end

  private
    def apply_redirect(notice)
      if params[:apply].presence
        redirect_to [:edit, :admin, :global_settings, @global_menu_item], notice: notice
      else
        redirect_to [:admin, :global_settings, :global_menu_items], notice: notice
      end
    end

    def authorize_global_menu_item
      authorize :global_menu_item, :user_has_rights?
    end

    def set_global_menu_item
      @global_menu_item = GlobalMenuItem.find(params[:id])
    end

    def global_menu_item_params
      params.require(:global_menu_item).permit(:title, :caption, :type, :position, :parent_id, :url, :page_id)
    end
end
end
end
