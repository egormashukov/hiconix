class Admin::InstallFeatureProductSetsController < Admin::ApplicationController
  before_action :set_install_feature_product_set, only: [:destroy, :togglevisible]

  def togglevisible
    @install_feature_product_set.toggle(:visible)
    @install_feature_product_set.save
  end
  

  def sort
    InstallFeatureProductSet.sort(params[:install_feature_product_set])
    render :nothing => true
  end
  
  def create
    @install_feature_product_set = InstallFeatureProductSet.new(install_feature_product_set_params)
    if @install_feature_product_set.save
      @notice = "#{InstallFeatureProductSet.model_name.human} #{t 'flash.notice.was_added'}"
    else
      @error_message = "#{InstallFeatureProductSet.model_name.human} #{t 'flash.notice.cant_be_created'}"
    end
  end

  def destroy
    @install_feature_product_set.destroy
    @notice = "#{InstallFeatureProductSet.model_name.human} #{t 'flash.notice.was_deleted'}"
  end

private

  def set_install_feature_product_set
    @install_feature_product_set = InstallFeatureProductSet.find(params[:id])
  end

  def install_feature_product_set_params
    params.require(:install_feature_product_set).permit(:install_feature_id, :product_set_id, :position, :visible)
  end
end