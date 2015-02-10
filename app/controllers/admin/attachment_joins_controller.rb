# encoding: utf-8
class Admin::AttachmentJoinsController < Admin::ApplicationController
  before_action :authorize_catalog

  def togglevisible
    @attachment_join = AttachmentJoin.find(params[:id])
    @attachment_join.toggle(:visible)
    @attachment_join.save
    render :nothing => true
  end

  def sort
    params[:attachment_join].each_with_index do |id, idx|
      @attachment_join = AttachmentJoin.find(id)
      @attachment_join.position = idx
      @attachment_join.save
    end
    render :nothing => true
  end

  def edit
    @attachment_join = AttachmentJoin.find(params[:id])
  end

  def create
    get_attachmentable
    @attachment_join = @attachmentable.attachment_joins.create(attachment_join_params)
  end

  def update
    @attachment_join = AttachmentJoin.find(params[:id])
    @attachment_join.update_attributes(attachment_join_params)
  end

  def destroy
    @attachment_join = AttachmentJoin.find(params[:id])
    @attachmentable = @attachment_join.attachmentable
    @attachment_join.destroy
  end

  def get_attachmentable
    @attachmentable = LowCategory.find(attachment_join_params['attachmentable_id'])
  end

  def attachment_join_params
    params.require(:attachment_join).permit(:attachmentable_id, :position, :visible , :attachment_id)
  end

  def authorize_catalog
    authorize :catalog, :user_has_rights?
  end
end
