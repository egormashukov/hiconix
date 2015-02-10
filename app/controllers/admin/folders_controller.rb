# encoding: utf-8
class Admin::FoldersController < Admin::ApplicationController

  def index
    @folders = Folder.order(:slug).order(:title)
  end

  def new
    @folder = Folder.new
  end
  
  def edit
    @folder = Folder.find(params[:id])
  end



  def index
    load_folders
  end

  def new
    build_folder
  end

  def create
    build_folder
    save_folder || render(:new)
  end

  def edit
    load_folder
    build_folder
  end

  def update
    load_folder
    build_folder
    check_property_changed
    save_folder || render(:edit)
  end

  def destroy
    load_folder
    @folder.destroy
    redirect_to [:admin, :folders]
  end

  private

  def load_folders
    @folders ||= folder_scope.to_a
  end

  def load_folder
    @folder ||= folder_scope.find(params[:id])
  end

  def folder_scope
    # TODO: make policy_scope work
    # policy_scope(Folder).all.order(:position)
    Folder.all
  end

  def build_folder
    @folder ||= folder_scope.build
    @folder.attributes = folder_params
  end

  def save_folder
    apply_redirect if @folder.save
  end

  def apply_redirect(notice = '')
    if params[:apply].present?
      redirect_to [:edit, :admin, @folder], notice: notice
    else
      redirect_to [:admin, :folders], notice: notice
    end
  end

  def folder_params
    return {} if params[:folder].blank?
    params.require(:folder).permit(:title, :description)
  end
end
