class Admin::FilterCatalogueBrandLinkTypeCategoriesController < Admin::ApplicationController
  before_action :authorize_catalog_filter

  def index
    load_brands
    load_type_categories
  end

  def edit
    load_catalogue_brand_link_type_category
    build_catalogue_brand_link_type_category
    @filters = @assoc.filters
  end

  def update
    load_catalogue_brand_link_type_category
    build_catalogue_brand_link_type_category
    save_catalogue_brand_link_type_category || render(:edit)
  end

  def create
    build_filter_catalogue_brand_link_type_category
    save_filter_catalogue_brand_link_type_category
  end

  def destroy

  end

private

  def load_type_categories
    @type_categories ||= type_category_scope.where('id in (?)', CatalogueBrandLinkTypeCategory.pluck(:type_category_id))
  end

  def load_brands
    @brands ||= brand_scope.where('id in (?)', CatalogueBrandLinkTypeCategory.pluck(:catalogue_brand_link_id))
  end

  def load_catalogue_brand_link_type_category
    @assoc ||= catalogue_brand_link_type_category_scope.find(params[:id])
  end

  def catalogue_brand_link_type_category_scope
    CatalogueBrandLinkTypeCategory
  end

  def filter_catalogue_brand_link_type_category_scope
    FilterCatalogueBrandLinkTypeCategory.all
  end

  def brand_scope
    CatalogueBrandLink.where(tenant_id: Tenant.current_id)
  end

  def type_category_scope
    TypeCategory.where(tenant_id: Tenant.current_id)
  end

  def build_catalogue_brand_link_type_category
    @assoc ||= brand_scope.build
    @assoc.attributes = brand_params
  end

  def build_filter_catalogue_brand_link_type_category
    @filter ||= filter_catalogue_brand_link_type_category_scope.build
    @filter.attributes = filter_catalogue_brand_link_type_category_params
  end

  def save_catalogue_brand_link_type_category
    apply_redirect if @assoc.save
  end

  def save_filter_catalogue_brand_link_type_category
    @filter.save
  end

  def apply_redirect(notice = '')
    if params[:apply].present?
      redirect_to [:edit, :admin, :filters_sets, id: @assoc.id], notice: notice
    else
      redirect_to [:admin, :filters_sets], notice: notice
    end
  end

  def authorize_catalog_filter
    authorize :catalog_filter, :user_has_rights?
  end

  def brand_params
    return {} if params[:catalogue_brand_link].blank?
    params.require(:catalogue_brand_link).permit(:filter_id, :catalogue_brand_link_type_category_id, :position, :visible)
  end

  def filter_catalogue_brand_link_type_category_params
    return {} if params[:filter_catalogue_brand_link_type_category].blank?
    params.require(:filter_catalogue_brand_link_type_category).permit(:filter_id, :catalogue_brand_link_type_category_id)
  end
end