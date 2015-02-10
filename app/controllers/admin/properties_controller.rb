class Admin::PropertiesController < Admin::ApplicationController
  before_action :set_property, only: [:edit, :update, :destroy ]
  helper_method :apply_redirect

  def index
    @properties = Property.order(:created_at)
  end

  def new
    @property = Property.new
  end

  def create
    @property = Property.new(property_params)
    if @property.save
      notice = "#{Property.model_name.human} #{t 'flash.notice.was_added'}"
      apply_redirect(notice)
    else
      render action: 'new'
    end
  end

  def edit
  end

  def update
    if @property.update(property_params)
      notice = "#{Property.model_name.human} #{t 'flash.notice.was_updated'}"
      apply_redirect(notice)
    else
      render action: 'edit'
    end
  end

  def destroy
    @property.destroy
    redirect_to [:admin, :properties], notice: "#{Property.model_name.human} #{t 'flash.notice.was_deleted'}"
  end

  private

  def apply_redirect(notice)
    if params[:apply].presence
      if @property.profile_id.presence
        redirect_to edit_admin_property_path(@property, profile_id: @property.profile_id), notice: notice
      else
        redirect_to edit_admin_property_path(@property), notice: notice
      end
    else
      if @property.profile_id.presence
        redirect_to edit_admin_profile_path(@property.profile_id), notice: notice
      else
        redirect_to admin_properties_path, notice: notice
      end
    end
  end

    def set_property
      @property = Property.find(params[:id])
    end

    def property_params
      params.require(:property).permit(:profile_id, :title, :measurement_unit, :hiconix_code, :type, :description, :desc_url, :dynamic_string, :seo, :tenant_id)
    end
end