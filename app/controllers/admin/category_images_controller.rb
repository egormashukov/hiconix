#coding: utf-8
class Admin::CategoryImagesController < Admin::ApplicationController
  before_action :set_category_image, only: [:edit, :update, :destroy , :togglevisible]
  helper_method :apply_redirect


  def togglevisible
    @category_image.toggle(:visible)
    @category_image.save
  end
  

  def sort
    CategoryImage.sort(params[:category_image])
    render :nothing => true
  end
  
  def edit
  end
  
  def create
    @category = Category.find(params[:category_id])
    @category_image = @category.category_images.create(category_image_params)
  end

  def update
    if @category_image.update_attributes(category_image_params)
      notice = "#{CategoryImage.model_name.human} #{t 'flash.notice.was_updated'}"
      apply_redirect(notice) 
    else
      render 'edit'
    end
  end
  
  def destroy
    @category_image.destroy
  end

private

  def apply_redirect(notice)
    if params[:apply].presence
      redirect_to [:edit, :admin, @category_image], notice: notice
    else
      redirect_to [:edit, :admin, @category_image.category], notice: notice
    end
  end

  def set_category_image
    @category_image = CategoryImage.find(params[:id])
  end

  def category_image_params
    params.require(:category_image).permit(:crop_x, :crop_y, :crop_w, :crop_h, :image, :category_id, :position, :visible, :image_cache, :title)
  end
end