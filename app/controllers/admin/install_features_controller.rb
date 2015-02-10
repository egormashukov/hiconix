class Admin::InstallFeaturesController < Admin::ApplicationController
  before_action :set_install_feature, only: [:edit, :update, :destroy ]
  helper_method :apply_redirect

  def sort
    InstallFeature.sort(params[:install_feature])
    render :nothing => true
  end

  def index
    @install_features = InstallFeature.order(:position)
  end

  def new
    @install_feature = InstallFeature.new
  end

  def create
    @install_feature = InstallFeature.new(install_feature_params)
    if @install_feature.save
      notice = "#{InstallFeature.model_name.human} #{t 'flash.notice.was_added'}"
      apply_redirect(notice)
    else
      render action: 'new'
    end
  end

  def edit
  end

  def update
    if @install_feature.update(install_feature_params)
      notice = "#{InstallFeature.model_name.human} #{t 'flash.notice.was_updated'}"
      apply_redirect(notice)
    else
      render action: 'edit'
    end
  end

  def destroy
    @install_feature.destroy
    redirect_to [:admin, :install_features], notice: "#{InstallFeature.model_name.human} #{t 'flash.notice.was_deleted'}"
  end

  private

  def apply_redirect(notice)
    obj = @install_feature.categories.last.presence || @install_feature.products.last.presence || @install_feature.product_sets.last.presence
    redirect_to [:edit, :admin, obj], notice: notice
  end

    def set_install_feature
      @install_feature = InstallFeature.find(params[:id])
    end

    def install_feature_params
      params.require(:install_feature).permit(:product_set_id, :product_id, :category_id, :title, :url, :position)
    end
end