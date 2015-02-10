class Admin::InstallFeatureProductsController < Admin::ApplicationController
  before_action :set_install_feature_product, only: [:destroy, :togglevisible]

  def togglevisible
    @install_feature_product.toggle(:visible)
    @install_feature_product.save
  end
  

  def sort
    InstallFeatureProduct.sort(params[:install_feature_product])
    render :nothing => true
  end
  
  def create
    @install_feature_product = InstallFeatureProduct.new(install_feature_product_params)
    if @install_feature_product.save
      @notice = "#{InstallFeatureProduct.model_name.human} #{t 'flash.notice.was_added'}"
    else
      @error_message = "#{InstallFeatureProduct.model_name.human} #{t 'flash.notice.cant_be_created'}"
    end
  end

  def destroy
    @install_feature_product.destroy
    @notice = "#{InstallFeatureProduct.model_name.human} #{t 'flash.notice.was_deleted'}"
  end

private

  def set_install_feature_product
    @install_feature_product = InstallFeatureProduct.find(params[:id])
  end

  def install_feature_product_params
    params.require(:install_feature_product).permit(:install_feature_id, :product_id, :position, :visible)
  end
end