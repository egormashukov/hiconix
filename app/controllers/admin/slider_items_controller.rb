class Admin::SliderItemsController < Admin::ApplicationController
  before_action :set_slider_item, only: [:edit, :update, :destroy , :togglevisible]
  before_action :geo_sets, only: [:new, :create, :edit, :update]
  before_action :page, only: [:new, :create, :edit, :update]
  before_action :authorize_slider_item

  helper_method :apply_redirect

  def togglevisible
    @slider_item.toggle(:visible)
    @slider_item.save
  end

  def change_visible
    val = params[:invisible].presence ? false : true
    SliderItem.where("id IN (?)", params[:slider_item_ids]).update_all(visible: val)
    redirect_to :back
  end

  def sort
    SliderItem.sort(params[:slider_item])
    render :nothing => true
  end

  def index
    @page = Page.main
    @slider_items = @page.slider_items.by_position
  end

  def new
    @slider_item = @page.slider_items.build
  end

  def create
    @slider_item = @page.slider_items.build(slider_item_params)
    if @slider_item.save
      notice = "#{SliderItem.model_name.human} #{t 'flash.notice.was_added'}"
      apply_redirect(notice)
    else
      render action: 'new'
    end
  end

  def edit
  end

  def update
    if @slider_item.update(slider_item_params)
      notice = "#{SliderItem.model_name.human} #{t 'flash.notice.was_updated'}"
      apply_redirect(notice)
    else
      render action: 'edit'
    end
  end

  def destroy
    @slider_item.destroy
    redirect_to [:admin, :slider_items], notice: "#{SliderItem.model_name.human} #{t 'flash.notice.was_deleted'}"
  end

  private
    def apply_redirect(notice)
      if params[:apply].presence
        redirect_to [:edit, :admin, @page, @slider_item], notice: notice
      else
        if @page.main?
          redirect_to [:admin, :slider_items], notice: notice
        else
          redirect_to [:edit, :admin, @page], notice: notice
        end
      end
    end

    def authorize_slider_item
      authorize :slider_item, :user_has_rights?
    end

    def set_slider_item
      @slider_item = SliderItem.find(params[:id])
    end

    def geo_sets
      @geo_sets = GeoSet.all#with_no_slider_items
    end

    def page
      @page = Page.find(params[:page_id])
    end

    def slider_item_params
      params.require(:slider_item).permit(:body, :slider_image, :page_id, :position, :visible, :title_mode, :geo_set_id, :hic_app)
    end
end