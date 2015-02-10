class Admin::RelatedProductsController < Admin::ApplicationController
  before_action :set_related_product, only: [:edit, :update, :destroy , :togglevisible]

  def togglevisible
    @related_product.toggle(:install_visible)
    @related_product.save
  end

  def sort
    RelatedProduct.sort(params[:related_product])
    render :nothing => true
  end

  def update
    if @related_product.update_attributes(related_product_params)
      notice = "#{RelatedProduct.model_name.human} #{t 'flash.notice.was_updated'}"
      apply_redirect(notice) 
    else
      render 'edit'
    end
  end

private

  def set_related_product
    @related_product = RelatedProduct.find(params[:id])
  end

end