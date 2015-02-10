class Admin::ProductOptionsController < Admin::ApplicationController
  before_action :set_product_option, only: [:update, :destroy , :togglevisible]

  def togglevisible
    @product_option.toggle(:install_visible)
    @product_option.save
  end

  def sort
    ProductOption.sort(params[:product_option])
    render :nothing => true
  end

  def update
    if @product_option.update_attributes(product_option_params)
      notice = "#{ProductOption.model_name.human} #{t 'flash.notice.was_updated'}"
      apply_redirect(notice) 
    else
      render 'edit'
    end
  end

private

  def set_product_option
    @product_option = ProductOption.find(params[:id])
  end

end