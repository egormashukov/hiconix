class Admin::ProductsController < Admin::ApplicationController
  before_action :set_product, only: [:edit, :update, :destroy ]
  helper_method :apply_redirect

  def index
    @products = Product.order(:created_at)
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      notice = "#{Product.model_name.human} #{t 'flash.notice.was_added'}"
      apply_redirect(notice)
    else
      render action: 'new'
    end
  end

  def edit
    @install_feature_products = @product.install_feature_products.by_position
  end

  def update
    if @product.update(product_params)
      notice = "#{Product.model_name.human} #{t 'flash.notice.was_updated'}"
      apply_redirect(notice)
    else
      render action: 'edit'
    end
  end

  def destroy
    @product.destroy
    redirect_to [:admin, :products], notice: "#{Product.model_name.human} #{t 'flash.notice.was_deleted'}"
  end

  private
    def apply_redirect(notice)
      if params[:apply].presence
        redirect_to [:edit, :admin, @product], notice: notice
      else
        redirect_to [:admin, :products], notice: notice
      end
    end

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:install_description, :install_teaser_desc)
      
    end
end