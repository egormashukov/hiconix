class Admin::AttachmentsController < Admin::ApplicationController
  before_action :authorize_catalog

  def togglevisible
    load_low_category_image
    @low_category_image.toggle(:visible)
    @low_category_image.save
  end

  def sort
    LowCategoryImage.sort(params[:low_category_image])
    render :nothing => true
  end

  def edit
    load_low_category_image
  end

  def create
    load_low_category
    create_low_category_image
  end

  def update
    load_low_category_image
    save_low_category_image
  end

  def destroy
    load_low_category_image
    destroy_low_category_image
  end

  private

  def load_low_category_image
    @low_category_image = LowCategoryImage.find(params[:id])
  end

  def load_low_category
    klass = [LowCategory].detect { |c| params["#{c.name.underscore}_id"] }
    @low_category = klass.find(params["#{klass.name.underscore}_id"])
  end

  def create_low_category_image
    @low_category_image = @low_category.low_category_images.create(low_category_image_params)
  end

  def save_low_category_image
    if @low_category_image.update_attributes(low_category_image_params)
      notice = "#{ProjectImage.model_name.human} #{t 'flash.notice.was_updated'}"
      apply_redirect(notice)
    else
      render 'edit'
    end
  end

  def destroy_low_category_image
    @low_category_image.destroy
  end

  def low_category_image_params
    params.require(:low_category_image).permit(:image, :low_category_id, :visible, :position, :image_cache, :title)
  end

  def apply_redirect(notice)
    if params[:apply].presence
      redirect_to [:edit, :admin, @low_category_image], notice: notice
    else
      redirect_to [:edit, :admin, @low_category_image.low_category], notice: notice
    end
  end

  def authorize_catalog
    authorize :catalog, :user_has_rights?
  end
end
