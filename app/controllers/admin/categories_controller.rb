class Admin::CategoriesController < Admin::ApplicationController
  before_action :set_category, only: [:edit, :update, :destroy , :togglevisible]
  helper_method :apply_redirect

  def togglevisible
    @category.toggle(:visible)
    @category.save
  end

  def change_visible
    val = params[:invisible].presence ? false : true
    Category.update_all({visible: val}, {id: params[:category_ids]})
    redirect_to :back
  end

  def sort
    Category.sort(params[:list])
    render :nothing => true
  end

  def index
    @categories = Category.order(:position)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      notice = "#{Category.model_name.human} #{t 'flash.notice.was_added'}"
      apply_redirect(notice)
    else
      render action: 'new'
    end
  end

  def edit
    @install_feature_categories = @category.install_feature_categories.by_position
    @product_sets = @category.product_sets

    if @category.try(:catalog_category_id).presence
      @catalog_category = Category.catalog_tree.find(@category.try(:catalog_category_id))
      @category_settings = @category.category_settings.includes(:low_level_category).where("low_level_category_id IN (?)", @catalog_category.category_settings.collect(&:low_level_category_id)).by_position
      @product_folders = @catalog_category.folder.try(:product_folders).includes(:product => :low_level_category).order(:install_position)
    end
    @category_images = @category.category_images.by_position
  end

  def update
    if @category.update(category_params)
      notice = "#{Category.model_name.human} #{t 'flash.notice.was_updated'}"
      apply_redirect(notice)
    else
      @install_feature_categories = @category.install_feature_categories.by_position
      @product_sets = @category.product_sets
      @category_images = @category.category_images.by_position
      if @category.try(:catalog_category_id).presence
        @catalog_category = Category.catalog_tree.find(@category.try(:catalog_category_id))
        @category_settings = @category.category_settings.includes(:low_level_category).where("low_level_category_id IN (?)", @catalog_category.category_settings.collect(&:low_level_category_id)).by_position
        @product_folders = @catalog_category.folder.try(:product_folders).includes(:product => :low_level_category).order(:install_position)
      end
      render action: 'edit'
    end
  end

  def destroy
    @category.destroy
    redirect_to [:admin, :categories], notice: "#{Category.model_name.human} #{t 'flash.notice.was_deleted'}"
  end

  private
    def apply_redirect(notice)
      if params[:apply].presence
        redirect_to [:edit, :admin, @category], notice: notice
      else
        redirect_to [:admin, :categories], notice: notice
      end
    end

    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:title, :brand_id, :folder_id, :description, :teaser_desc, :image, :slug, :ancestry, :visible, :position, :table_mode, :child_desc_mode, :file_mode, :h_code, :tree, :tenant_id, :menu_title, :hic_app, :image_cache, :catalog_category_id, :table_set_profile_id, price_modifiers_attributes: [:value, :geo_set_id, :id])

    end
end