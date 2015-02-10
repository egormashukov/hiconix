class Admin::FiltersSetsController < Admin::ApplicationController
  before_action :authorize_catalog_filter

  def togglevisible
    @filter_set = FilterCatalogueBrandLinkTypeCategory.find(params[:id])
    @filter_set.toggle(:visible)
    @filter_set.save
    render 'admin/filters_sets/togglevisible.js.coffee'
  end

  def sort
    FilterCatalogueBrandLinkTypeCategory.sort(params[:filters_set])
    render :nothing => true
  end

  def edit
    load_assoc
    load_filters_set
  end

  def create
    load_assoc_through_filter_params
    @filter_set = filter_catalogue_brand_link_type_category_scope.create(filter_catalogue_brand_link_type_category_params)
  end

  def destroy
    load_filter_set
    load_assoc_through_filter_params
    destroy_filter_set
  end

private

  def load_filters_set
    @filters_set = filter_catalogue_brand_link_type_category_scope.where(catalogue_brand_link_type_category_id: params[:id])
  end

  def load_assoc
    @assoc ||= catalogue_brand_link_type_category_scope.find(params[:id])
  end

  def load_assoc_through_filter_params
    @assoc ||= catalogue_brand_link_type_category_scope.find(filter_catalogue_brand_link_type_category_params[:catalogue_brand_link_type_category_id])
  end

  def load_filter_set
    @filter = filter_catalogue_brand_link_type_category_scope.find(params[:id])
  end

  def destroy_filter_set
    @filter.destroy
  end

  def filter_catalogue_brand_link_type_category_scope
    FilterCatalogueBrandLinkTypeCategory
  end

  def catalogue_brand_link_type_category_scope
    CatalogueBrandLinkTypeCategory
  end

  def save_filters_set
    @filter_set.save
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

  def filter_catalogue_brand_link_type_category_params
    return {} if params[:filter_catalogue_brand_link_type_category].blank?
    params.require(:filter_catalogue_brand_link_type_category).permit(:filter_id, :catalogue_brand_link_type_category_id,
                                                                      :position, :visible)
  end
end