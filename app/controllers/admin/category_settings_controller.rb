class Admin::CategorySettingsController < Admin::ApplicationController

  def sort
    CategorySetting.sort(params[:category_setting])
    render :nothing => true
  end

  def update
    @category_setting = CategorySetting.find(params[:id])
    
    @category_setting.update_attributes(category_settings_params)
    redirect_to :back
  end

  private
    def category_settings_params
      params.require(:category_setting).permit(:profile_id, :set_profile_id, :visible)
    end
end