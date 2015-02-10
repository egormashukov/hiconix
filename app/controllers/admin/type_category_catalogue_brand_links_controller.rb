class Admin::TypeCategoryCatalogueBrandLinksController < Admin::ApplicationController
  before_action :authorize_catalog

  def create
    new_type_category_catalogue_brand_link
    save_type_category_catalogue_brand_link
  end

  def destroy
    load_type_category_catalogue_brand_link
    destroy_type_category_catalogue_brand_link
  end

private

  def new_type_category_catalogue_brand_link
    @type_category_catalogue_brand_link = TypeCategoryCatalogueBrandLink.new(type_category_catalogue_brand_link_params)
  end

  def load_type_category_catalogue_brand_link
    @type_category_catalogue_brand_link = TypeCategoryCatalogueBrandLink.find(params[:id])
  end

  def save_type_category_catalogue_brand_link
    if @type_category_catalogue_brand_link.save
      @notice = "#{TypeCategoryCatalogueBrandLink.model_name.human} #{t 'flash.notice.was_added'}"
    else
      @error_message = "#{TypeCategoryCatalogueBrandLink.model_name.human} #{t 'flash.notice.cant_be_created'}"
    end
  end

  def destroy_type_category_catalogue_brand_link
    @type_category_catalogue_brand_link.destroy
    @notice = "#{TypeCategoryCatalogueBrandLink.model_name.human} #{t 'flash.notice.was_deleted'}"
  end

  def type_category_catalogue_brand_link_params
    params.require(:type_category_catalogue_brand_link).permit(:title, :show_category, :show_brand, :catalogue_brand_link_type_category_id, :catalogue_brand_link_id, :type_category_id)
  end

  def authorize_catalog
    authorize :catalog, :user_has_rights?
  end
end