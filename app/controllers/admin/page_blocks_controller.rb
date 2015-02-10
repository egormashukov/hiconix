class Admin::PageBlocksController < Admin::ApplicationController
  before_action :set_page_block, only: [:destroy, :togglevisible, :canonical, :update]
  before_action :authorize_page


  def canonical
    @page_block.block.page_blocks.each do |pb|
      pb.update(canonical:false)
    end
    @page_block.canonical = true
    @page_block.save
    redirect_to :back
  end

  def togglevisible
    @page_block.toggle(:visible)
    @page_block.save
  end


  def sort
    PageBlock.sort(params[:page_block])
    render :nothing => true
  end

  def create
    @page_block = PageBlock.new(page_block_params)
    if @page_block.save
      @notice = "#{PageBlock.model_name.human} #{t 'flash.notice.was_added'}"
    else
      @error_message = "#{PageBlock.model_name.human} #{t 'flash.notice.cant_be_created'}"
    end
  end

  def update
    @page_block.update_attributes(page_block_params)
    render nothing: true
  end

  def destroy
    @page_block.destroy
    @notice = "#{PageBlock.model_name.human} #{t 'flash.notice.was_deleted'}"
  end

private

  def authorize_page
    authorize :page, :user_has_rights?
  end

  def set_page_block
    @page_block = PageBlock.find(params[:id])
  end

  def page_block_params
    params.require(:page_block).permit(:page_id, :block_id, :teaser_modificator, :sort_modificator, :position, :visible, :social_modificator, :canonical, :list_style)
  end
end