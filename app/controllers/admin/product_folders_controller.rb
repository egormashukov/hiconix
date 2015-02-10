class Admin::ProductFoldersController < Admin::ApplicationController
  before_action :set_product_folder, only: [:edit, :update, :destroy , :togglevisible]

  def togglevisible
    @product_folder.toggle(:install_visible)
    @product_folder.save
  end

  def sort
    ProductFolder.sort(params[:product_folder])
    render :nothing => true
  end


private

  def set_product_folder
    @product_folder = ProductFolder.find(params[:id])
  end

end