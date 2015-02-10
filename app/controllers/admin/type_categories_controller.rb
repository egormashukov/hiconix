class Admin::TypeCategoriesController < Admin::ApplicationController
  before_action :authorize_catalog_type_category

  def togglevisible
    @type_category = TypeCategory.find(params[:id])
    @type_category.toggle(:visible)
    @type_category.save
    render 'admin/type_categories/togglevisible.js.coffee'
  end

  def change_visible
    val = params[:invisible].presence ? false : true
    TypeCategory.where({id: params[:type_category_ids]}).update_all({visible: val})
    redirect_to :back
  end

  def sort
    TypeCategory.sort(params[:type_category])
    render :nothing => true
  end

  def index
    load_type_categories
  end

  def new
    build_type_category
  end

  def create
    build_type_category
    save_type_category || render(:new)
  end

  def edit
    load_type_category
    @type_category_catalogue_brand_links = @type_category.type_category_catalogue_brand_links
    build_type_category
  end

  def update
    load_type_category
    build_type_category
    save_type_category || render(:edit)
  end

  def destroy
    load_type_category
    @type_category.destroy
    redirect_to [:admin, :type_categories]
  end

  private

  def load_type_categories
    @type_categories ||= type_category_scope.to_a
  end

  def load_type_category
    @type_category ||= type_category_scope.find(params[:id])
  end

  def type_category_scope
    # TODO: make policy_scope work
    # policy_scope(Brand).all.order(:position)
    TypeCategory.where(tenant_id: Tenant.current_id).order(:position)
  end

  def build_type_category
    @type_category ||= type_category_scope.build
    @type_category.attributes = type_category_params
  end

  def save_type_category
    apply_redirect if @type_category.save
  end

  def apply_redirect(notice = '')
    if params[:apply].present?
      redirect_to [:edit, :admin, @type_category], notice: notice
    else
      redirect_to [:admin, :type_categories], notice: notice
    end
  end

  def authorize_catalog_type_category
    authorize :catalog_type_category, :user_has_rights?
  end

  def type_category_params
    return {} if params[:type_category].blank?
    params.require(:type_category).permit(:low_category_id, :catalogue_brand_link_id, :title,
                                          :visible, :grouping, :description, :teaser_desc)
  end
end
