class Admin::TypeCategoryLowCategoriesController < Admin::ApplicationController
  before_action :authorize_catalog

  def create
    new_type_category_low_category
    save_type_category_low_category
  end

  def destroy
    load_type_category_low_category
    destroy_type_category_low_category
  end

private

  def new_type_category_low_category
    @type_category_low_category = TypeCategoryLowCategory.new(type_category_low_category_params)
  end

  def load_type_category_low_category
    @type_category_low_category = TypeCategoryLowCategory.find(params[:id])
  end

  def save_type_category_low_category
    if @type_category_low_category.save
      @notice = "#{TypeCategoryLowCategory.model_name.human} #{t 'flash.notice.was_added'}"
    else
      @error_message = "#{TypeCategoryLowCategory.model_name.human} #{t 'flash.notice.cant_be_created'}"
    end
  end

  def destroy_type_category_low_category
    @type_category_low_category.destroy
    @notice = "#{TypeCategoryLowCategory.model_name.human} #{t 'flash.notice.was_deleted'}"
  end

  def type_category_low_category_params
    params.require(:type_category_low_category).permit(:low_category_id, :type_category_id)
  end

  def authorize_catalog
    authorize :catalog, :user_has_rights?
  end
end