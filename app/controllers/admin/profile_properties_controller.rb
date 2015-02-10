class Admin::ProfilePropertiesController < Admin::ApplicationController
  before_action :set_profile_property, only: [:destroy, :togglevisible, :update]

  def togglevisible
    @profile_property.toggle(:visible)
    @profile_property.save
  end
  

  def sort
    ProfileProperty.sort(params[:profile_property])
    render :nothing => true
  end
  
  def create
    @profile_property = ProfileProperty.new(profile_property_params)
    if @profile_property.save
      @notice = "#{ProfileProperty.model_name.human} #{t 'flash.notice.was_added'}"
    else
      @error_message = "#{ProfileProperty.model_name.human} #{t 'flash.notice.cant_be_created'}"
    end
  end

  def update
    @profile_property.assign_attributes(profile_property_params)
    @profile_property.units_array = params[:profile_property][:units_array]
    if @profile_property.save
      @notice = "#{ProfileProperty.model_name.human} #{t 'flash.notice.was_added'}"
    else
      @error_message = "#{ProfileProperty.model_name.human} #{t 'flash.notice.cant_be_created'}"
    end
    render nothing: true
  end

  def destroy
    @profile_property.destroy
    @notice = "#{ProfileProperty.model_name.human} #{t 'flash.notice.was_deleted'}"
  end

private

  def set_profile_property
    @profile_property = ProfileProperty.find(params[:id])
  end

  def profile_property_params
    params.require(:profile_property).permit(:profile_id, :property_id, :visible, :position, :measurement_unit, :short_title, :units, :precision, :tenant_id, :sort_priority, :product_set_priority, :units_array)
  end
end