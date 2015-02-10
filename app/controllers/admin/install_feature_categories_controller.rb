class Admin::InstallFeatureCategoriesController < Admin::ApplicationController
  before_action :set_install_feature_category, only: [:destroy, :togglevisible]

  def togglevisible
    @install_feature_category.toggle(:visible)
    @install_feature_category.save
  end
  

  def sort
    InstallFeatureCategory.sort(params[:install_feature_category])
    render :nothing => true
  end
  
  def create
    @install_feature_category = InstallFeatureCategory.new(install_feature_category_params)
    if @install_feature_category.save
      @notice = "#{InstallFeatureCategory.model_name.human} #{t 'flash.notice.was_added'}"
    else
      @error_message = "#{InstallFeatureCategory.model_name.human} #{t 'flash.notice.cant_be_created'}"
    end
  end

  def destroy
    @install_feature_category.destroy
    @notice = "#{InstallFeatureCategory.model_name.human} #{t 'flash.notice.was_deleted'}"
  end

private

  def set_install_feature_category
    @install_feature_category = InstallFeatureCategory.find(params[:id])
  end

  def install_feature_category_params
    params.require(:install_feature_category).permit(:install_feature_id, :category_id, :position, :visible)
  end
end