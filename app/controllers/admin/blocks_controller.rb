class Admin::BlocksController < Admin::ApplicationController
  before_action :set_block, only: [:edit, :update, :destroy]
  before_action :authorize_block
  helper_method :apply_redirect

  def index
    @blocks = policy_scope(Block).order(:created_at)
    # @blocks = Block.order(:created_at)
  end

  def new
    @block = Block.new
  end

  def create
    @block = Block.new(block_params)
    if @block.save
      notice = "#{Block.model_name.human} #{t 'flash.notice.was_added'}"
      apply_redirect(notice)
    else
      render action: 'new'
    end
  end

  def edit
    @contents = @block.contents.by_position
    @page_blocks = @block.page_blocks.order(:created_at)
  end

  def update
    if @block.update(block_params)
      notice = "#{Block.model_name.human} #{t 'flash.notice.was_updated'}"
      apply_redirect(notice)
    else
      render action: 'edit'
    end
  end

  def destroy
    @block.destroy
    redirect_to [:admin, :blocks], notice: "#{Block.model_name.human} #{t 'flash.notice.was_deleted'}"
  end

  private

  def apply_redirect(notice)
    if params[:apply].presence
      if @block.page_id.presence
        redirect_to edit_admin_block_path(@block, page_id: @block.page_id), notice: notice
      else
        redirect_to edit_admin_block_path(@block), notice: notice
      end
    else
      if @block.page_id.presence
        redirect_to edit_admin_page_path(@block.page_id), notice: notice
      else
        redirect_to admin_blocks_path, notice: notice
      end
    end
  end

  def authorize_block
    authorize :block, :user_has_rights?
  end

  def set_block
    @block = Block.find(params[:id])
  end

  def block_params
    params.require(:block).permit(:page_id, :title)
  end
end