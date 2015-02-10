class Admin::SmartSlidesController < Admin::ApplicationController
  before_action :set_smart_slide, only: [:edit, :update, :destroy , :togglevisible]
  helper_method :apply_redirect
  before_action :authorize_slider_item

  def togglevisible
    @smart_slide.toggle(:visible)
    @smart_slide.save
  end

  def change_visible
    val = params[:invisible].presence ? false : true
    SmartSlide.update_all({visible: val}, {id: params[:smart_slide_ids]})
    redirect_to :back
  end

  def sort
    SmartSlide.sort(params[:smart_slide])
    render :nothing => true
  end

  def index
    @smart_slides = SmartSlide.order(:position)
  end

  def new
    @smart_slide = SmartSlide.new
  end

  def create
    @smart_slide = SmartSlide.new(smart_slide_params)
    if @smart_slide.save
      notice = "#{SmartSlide.model_name.human} #{t 'flash.notice.was_added'}"
      apply_redirect(notice)
    else
      render action: 'new'
    end
  end

  def edit
  end

  def update
    if @smart_slide.update(smart_slide_params)
      notice = "#{SmartSlide.model_name.human} #{t 'flash.notice.was_updated'}"
      apply_redirect(notice)
    else
      render action: 'edit'
    end
  end

  def destroy
    @smart_slide.destroy
    redirect_to [:admin, :smart_slides], notice: "#{SmartSlide.model_name.human} #{t 'flash.notice.was_deleted'}"
  end

  private
    def apply_redirect(notice)
      if params[:apply].presence
        redirect_to [:edit, :admin, @smart_slide], notice: notice
      else
        redirect_to [:admin, :smart_slides], notice: notice
      end
    end

    def authorize_slider_item
      authorize :slider_item, :user_has_rights?
    end

    def set_smart_slide
      @smart_slide = SmartSlide.find(params[:id])
    end

    def smart_slide_params
      params.require(:smart_slide).permit(:position, :visible, :image, :link, :body, :image_cache, :icon_cache, :title, :icon)
    end
end