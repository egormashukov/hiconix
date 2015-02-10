class Admin::ContentsController < Admin::ApplicationController
  before_action :set_block, only: [:new, :create, :update, :edit]
  before_action :set_content, only: [:edit, :update, :destroy , :togglevisible]
  before_action :authorize_block
  helper_method :apply_redirect

  def togglevisible
    @content.toggle(:visible)
    @content.save
  end

  def change_visible
    val = params[:invisible].presence ? false : true
    Content.update_all({visible: val}, {id: params[:content_ids]})
    redirect_to :back
  end

  def sort
    Content.sort(params[:content])
    render :nothing => true
  end

  def index
    @contents = Content.order(:position)
  end

  def new
    @content = @block.contents.build
  end

  def create
    @content = @block.contents.build(content_params)
    if @content.save
      notice = "#{Content.model_name.human} #{t 'flash.notice.was_added'}"
      apply_redirect(notice)
    else
      render action: 'new'
    end
  end

  def edit
    @content_images = @content.content_images.by_position
  end

  def update
    if @content.update(content_params)
      notice = "#{Content.model_name.human} #{t 'flash.notice.was_updated'}"
      apply_redirect(notice)
    else
      render action: 'edit'
    end
  end

  def destroy
    @content.destroy
    @notice = "#{Content.model_name.human} #{t 'flash.notice.was_deleted'}"
  end

  private

  def set_block
    @block = Block.find(params[:block_id])
  end

  def apply_redirect(notice)
    if params[:apply].presence
      redirect_to [:edit, :admin, @block, @content], notice: notice
    else
      redirect_to [:edit, :admin, @block], notice: notice
    end
  end

  def authorize_block
    authorize :block, :user_has_rights?
  end

  def set_content
    @content = Content.find(params[:id])
  end

  def content_params
    params.require(:content).permit(:title, :block_id, :title_image, :teaser_body, :undercut_body, :position, :visible, :slug, :metadesc, :metakeywords, :ancestry, :start_date, :finish_date, :seo_title, :tenant_id, :location, :catalog_image)
  end
end