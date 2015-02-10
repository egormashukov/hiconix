module Admin
module GlobalSettings

class SubMenuItemsController < Admin::GlobalSettings::ApplicationController
  before_action :set_global_menu_item, except: [:sort, :destroy ]
  before_action :set_sub_menu_item, only: [:edit, :update, :destroy ]
  before_action :authorize_global_menu_item
  helper_method :apply_redirect

  skip_before_filter :current_tenant
  skip_around_filter :scope_current_tenant

  def sort
    SubMenuItem.sort(params[:sub_menu_item])
    render :nothing => true
  end

  def new
    @sub_menu_item = @global_menu_item.sub_menu_items.build
  end

  def create
    @sub_menu_item = @global_menu_item.sub_menu_items.build(sub_menu_item_params)
    if @sub_menu_item.save
      notice = "#{SubMenuItem.model_name.human} #{t 'flash.notice.was_added'}"
      apply_redirect(notice)
    else
      render action: 'new'
    end
  end

  def edit
  end

  def update
    if @sub_menu_item.update(sub_menu_item_params)
      notice = "#{SubMenuItem.model_name.human} #{t 'flash.notice.was_updated'}"
      apply_redirect(notice)
    else
      render action: 'edit'
    end
  end

  def destroy
    @sub_menu_item.destroy
    @notice = "#{SubMenuItem.model_name.human} #{t 'flash.notice.was_deleted'}"
  end

  private
    def set_global_menu_item
      @global_menu_item = GlobalMenuItem.find(params[:global_menu_item_id])
    end

    def apply_redirect(notice)
      if params[:apply].presence
        redirect_to [:edit, :admin, :global_settings, @global_menu_item, @sub_menu_item], notice: notice
      else
        redirect_to [:edit, :admin, :global_settings, @global_menu_item], notice: notice
      end
    end

    def authorize_global_menu_item
      authorize :global_menu_item, :user_has_rights?
    end

    def set_sub_menu_item
      @sub_menu_item = SubMenuItem.find(params[:id])
    end

    def sub_menu_item_params
      params.require(:sub_menu_item).permit(:title, :caption, :type, :position, :parent_id, :page_id, :url)
    end
end
end
end