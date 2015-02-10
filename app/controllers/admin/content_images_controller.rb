#coding: utf-8
class Admin::ContentImagesController < Admin::ApplicationController
  before_action :set_content_image, only: [:edit, :update, :destroy]
  helper_method :apply_redirect

  before_action :authorize_block
  # skip_before_filter :current_tenant
  # skip_around_filter :scope_current_tenant

  def sort
    ContentImage.sort(params[:content_image])
    render :nothing => true
  end

  def edit
  end

  def create
    @content = Content.find(params[:content_id])
    @content_image = @content.content_images.create(content_image_params)
  end

  def update
    if @content_image.update_attributes(content_image_params)
      notice = "#{ContentImage.model_name.human} #{t 'flash.notice.was_updated'}"
      apply_redirect(notice)
    else
      render 'edit'
    end
  end

  def destroy
    @content_image.destroy
  end

private

  def apply_redirect(notice)
    if params[:apply].presence
      redirect_to [:edit, :admin, @content_image], notice: notice
    else
      redirect_to [:edit, :admin, @content_image.content.block, @content_image.content, ], notice: notice
    end
  end

  def authorize_block
    authorize :block, :user_has_rights?
  end

  def set_content_image
    @content_image = ContentImage.find(params[:id])
  end

  def content_image_params
    params.require(:content_image).permit(:image, :title, :content_id, :position, :image_cache)
  end
end