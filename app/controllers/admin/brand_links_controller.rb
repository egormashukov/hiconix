class Admin::BrandLinksController < Admin::ApplicationController
  before_action :set_brand_link, only: [:edit, :update, :destroy, :togglevisible]
  before_action :authorize_brand_link#, except: [:index]
  helper_method :apply_redirect

  def togglevisible
    @brand_link.toggle(:visible)
    @brand_link.save
  end
  def change_visible
    val = params[:invisible].presence ? false : true
    BrandLink.update_all({visible: val}, {id: params[:brand_link_ids]})
    redirect_to :back
  end

  def sort
    BrandLink.sort(params[:brand_link])
    render :nothing => true
  end

  def index
    @brand_links = policy_scope(BrandLink).order(:position)
  end

  def new
    @brand_link = BrandLink.new
  end

  def create
    @brand_link = BrandLink.new(brand_link_params)
    if @brand_link.save
      notice = "#{BrandLink.model_name.human} #{t 'flash.notice.was_added'}"
      apply_redirect(notice)
    else
      render action: 'new'
    end
  end

  def edit
  end

  def update
    if @brand_link.update(brand_link_params)
      notice = "#{BrandLink.model_name.human} #{t 'flash.notice.was_updated'}"
      apply_redirect(notice)
    else
      render action: 'edit'
    end
  end

  def destroy
    @brand_link.destroy
    redirect_to [:admin, :brand_links], notice: "#{BrandLink.model_name.human} #{t 'flash.notice.was_deleted'}"
  end

  private
    def apply_redirect(notice)
      if params[:apply].presence
        redirect_to [:edit, :admin, @brand_link], notice: notice
      else
        redirect_to [:admin, :brand_links], notice: notice
      end
    end

    def authorize_brand_link
      authorize :brand_link, :user_has_rights?
    end

    def set_brand_link
      @brand_link = BrandLink.find(params[:id])
    end

    def brand_link_params
      params.require(:brand_link).permit(:brand_id, :position, :visible, :link, :image, :slide_image, :slide_body, :image_cache, :icon_hover, :icon_hover_cache, :title )
    end
end