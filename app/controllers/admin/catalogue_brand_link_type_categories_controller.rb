class Admin::CatalogueBrandLinkTypeCategoriesController < Admin::ApplicationController
  before_action :authorize_catalog

  def create
    new_catalogue_brand_link_type_category
    save_catalogue_brand_link_type_category
  end

  # def edit
  #   load_catalogue_brand_link_type_category
  #   build_catalogue_brand_link_type_category
  # end

  def destroy
    load_catalogue_brand_link_type_category
    destroy_catalogue_brand_link_type_category
  end

private

  def new_catalogue_brand_link_type_category
    @catalogue_brand_link_type_category = CatalogueBrandLinkTypeCategory.new(catalogue_brand_link_type_category_params)
  end

  def load_catalogue_brand_link_type_category
    @catalogue_brand_link_type_category = CatalogueBrandLinkTypeCategory.find(params[:id])
  end

  def build_catalogue_brand_link_type_category
    @catalogue_brand_link_type_category ||= catalogue_brand_link_type_category_scope.build
    @catalogue_brand_link_type_category.attributes = catalogue_brand_link_type_category_params
  end

  def catalogue_brand_link_type_category_scope
    CatalogueBrandLinkTypeCategory
  end

  def save_catalogue_brand_link_type_category
    if @catalogue_brand_link_type_category.save
      @notice = "#{CatalogueBrandLinkTypeCategory.model_name.human} #{t 'flash.notice.was_added'}"
    else
      @error_message = "#{CatalogueBrandLinkTypeCategory.model_name.human} #{t 'flash.notice.cant_be_created'}"
    end
  end

  def destroy_catalogue_brand_link_type_category
    @catalogue_brand_link_type_category.destroy
    @notice = "#{CatalogueBrandLinkTypeCategory.model_name.human} #{t 'flash.notice.was_deleted'}"
  end

  def catalogue_brand_link_type_category_params
    return {} if params[:catalogue_brand_link_type_category].blank?
    params.require(:catalogue_brand_link_type_category).permit(:title, :show_category, :show_brand, :catalogue_brand_link_type_category_id, :catalogue_brand_link_id, :type_category_id)
  end

  def authorize_catalog
    authorize :catalog, :user_has_rights?
  end
end