class Admin::ProfilesController < Admin::ApplicationController
  before_action :set_profile, only: [:edit, :update, :destroy ]
  helper_method :apply_redirect

  def index
    @profiles = Profile.order(:created_at)
  end

  def new
    @profile = Profile.new
  end

  def create
    @profile = Profile.new(profile_params)
    if @profile.save
      notice = "#{Profile.model_name.human} #{t 'flash.notice.was_added'}"
      apply_redirect(notice)
    else
      render action: 'new'
    end
  end

  def edit
    @profile_properties = @profile.profile_properties.by_position
  end

  def update
    if @profile.update(profile_params)
      notice = "#{Profile.model_name.human} #{t 'flash.notice.was_updated'}"
      apply_redirect(notice)
    else
      render action: 'edit'
    end
  end

  def destroy
    @profile.destroy
    redirect_to [:admin, :profiles], notice: "#{Profile.model_name.human} #{t 'flash.notice.was_deleted'}"
  end

  private
    def apply_redirect(notice)
      if params[:apply].presence
        redirect_to [:edit, :admin, @profile], notice: notice
      else
        redirect_to [:admin, :profiles], notice: notice
      end
    end

    def set_profile
      @profile = Profile.find(params[:id])
    end

    def profile_params
      params.require(:profile).permit(:title, :horizontal_properties, :font, :zebra, :highlight, :link_fill_row, :show_desc, :units_in_cell, :tenant_id, :products_count)
    end
end