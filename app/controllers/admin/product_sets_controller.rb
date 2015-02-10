class Admin::ProductSetsController < Admin::ApplicationController
  before_action :set_product_set, only: [:edit, :update, :destroy, :togglevisible]
  before_action :set_category, except: [:destroy, :togglevisible, :sort]
  helper_method :apply_redirect

  def togglevisible
    @product_set.toggle(:visible)
    @product_set.save
  end

  def sort
    ProductSet.sort(params[:product_set])
    render :nothing => true
  end

  def new
    @product_set = @category.product_sets.build
    @product_set.product = Product.find(params[:product_id])
  end

  def create
    @product_set = @category.product_sets.build(product_set_params)
    @product_set.products_ids = params[:product_set][:products_ids]
    if @product_set.save
      notice = "#{ProductSet.model_name.human} #{t 'flash.notice.was_added'}"
      apply_redirect(notice)
    else
      render action: 'new'
    end
  end

  def edit
    @products = @product_set.products
    @install_feature_product_sets = @product_set.install_feature_product_sets.by_position
  end

  def update
    @product_set.assign_attributes(product_set_params)
    @product_set.products_ids = params[:product_set][:products_ids]
    if @product_set.save
      notice = "#{ProductSet.model_name.human} #{t 'flash.notice.was_updated'}"
      apply_redirect(notice)
    else
      @products = @product_set.products
      render action: 'edit'
    end
  end

  def destroy
    @product_set.destroy
    redirect_to :back, notice: "#{ProductSet.model_name.human} #{t 'flash.notice.was_deleted'}"
  end

  private
    def apply_redirect(notice)
      if params[:apply].presence
        redirect_to [:edit, :admin, @category, @product_set], notice: notice
      else
        redirect_to [:edit, :admin, @category], notice: notice
      end
    end

    def set_category
      @category = Category.find(params[:category_id])
    end

    def set_product_set
      @product_set = ProductSet.find(params[:id])
    end

    def product_set_params
      params.require(:product_set).permit(:products_ids, :category_id, :product_id, :teaser, :description, :image, :show_options, :show_related, :image_cache, :title, :visible, :position)

    end
end