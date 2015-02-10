class Admin::Aux::NodesController < Admin::Aux::ApplicationController
  before_action :authorize_catalog_low_category

  def index
    load_low_categories
  end

  def new
    build_low_category
  end

  def create
    build_low_category
    save_low_category || render(:new)
  end

  def edit
    load_low_category
    @type_category_low_categories = @low_category.type_category_low_categories
    @low_category_images = @low_category.low_category_images
    @attachment_joins = @low_category.attachment_joins.by_position
    build_low_category
    load_nested_low_categories
    load_loose_low_categories
  end

  def update
    load_low_category
    build_low_category
    save_low_category || render(:edit)
  end

  def destroy
    load_low_category
    @low_category.destroy
    redirect_to [:admin, :low_categories]
  end

  def add_common_category
    load_low_category
    load_modify_low_category
    @modify_low_category.update_attribute(:common_category_id, @low_category.id)
    load_loose_low_categories
  end

  def delete_common_category
    load_modify_low_category
    @modify_low_category.update_attribute(:common_category_id, nil)
    load_loose_low_categories
  end

  private

  def load_loose_low_categories
    @loose_low_categories = LowCategory.without_common_category.with_tenant.belongs_to_folder_with_properties
  end

  def load_modify_low_category
    @modify_low_category ||= low_category_unscoped.find(params[:modify_low_category_id])
  end

  def load_nested_low_categories
    @nested_low_categories = @low_category.nested_low_categories.with_tenant
  end

  def load_low_categories
    @nodes ||= nodes_scope.to_a
  end

  def load_low_category
    @low_category ||= low_category_scope.find(params[:id])
  end

  def nodes_scope
    []
  end

  def low_category_unscoped
    LowCategory.unscoped.order(:position)
  end

  def build_low_category
    @low_category ||= low_category_scope.build
    @low_category.attributes = low_category_params
  end

  def save_low_category
    apply_redirect if @low_category.save
  end

  def apply_redirect(notice = '')
    if params[:apply].present?
      redirect_to [:edit, :admin, :aux, @low_category], notice: notice
    else
      redirect_to [:admin, :aux, :low_categories], notice: notice
    end
  end

  def authorize_catalog_low_category
    authorize :catalog_low_category, :user_has_rights?
  end

  def low_category_params
    return {} if params[:low_category].blank?
    params.require(:low_category).permit(:title, :brand_id, :folder_id, :description,
                                          :teaser_desc, :image, :image_cache, :visible, :position,
                                          :table_mode, :child_desc_mode, :menu_title,
                                          category_settings_attributes: [:id, :visible, :title_visible,
                                                                         :prefix, :profile_id])
  end
end
