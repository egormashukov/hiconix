class Admin::CatalogueBrandLinksController < Admin::ApplicationController
  before_action :authorize_catalog_brand

  def togglevisible
    @brand = CatalogueBrandLink.find(params[:id])
    @brand.toggle(:visible)
    @brand.save
    render 'admin/catalogue_brand_links/togglevisible.js.coffee'
  end

  def change_visible
    val = params[:invisible].presence ? false : true
    CatalogueBrandLink.where({id: params[:brand_ids]}).update_all({visible: val})
    redirect_to :back
  end

  def sort
    CatalogueBrandLink.sort(params[:catalogue_brand_link])
    render :nothing => true
  end

  def index
    load_brands
  end

  def new
    build_brand
  end

  def create
    build_brand
    save_brand || render(:new)
  end

  def edit
    load_brand
    @catalogue_brand_link_type_categories = @brand.catalogue_brand_link_type_categories
    build_brand
  end

  def update
    load_brand
    build_brand
    save_brand || render(:edit)
  end

  def destroy
    load_brand
    @brand.destroy
    redirect_to [:admin, :brands]
  end

  private

  def load_brands
    @brands ||= brand_scope.to_a
  end

  def load_brand
    @brand ||= brand_scope.find(params[:id])
  end

  def brand_scope
    # TODO: make policy_scope work
    # policy_scope(Brand).all.order(:position)
    CatalogueBrandLink.where(tenant_id: Tenant.current_id).order(:position)
  end

  def build_brand
    @brand ||= brand_scope.build
    @brand.attributes = brand_params
  end

  def save_brand
    apply_redirect if @brand.save
  end

  def apply_redirect(notice = '')
    if params[:apply].present?
      redirect_to [:edit, :admin, :brand, id: @brand.id], notice: notice
    else
      redirect_to [:admin, :brands], notice: notice
    end
  end

  def authorize_catalog_brand
    authorize :catalog_brand, :user_has_rights?
  end

  def brand_params
    return {} if params[:catalogue_brand_link].blank?
    params.require(:catalogue_brand_link).permit(:type_category_id, :title, :visible, :description, :image, :hover_image, :brand_id, :type_category_id, :teaser_desc)
  end
end
