module Admin
  module GlobalSettings
    class BrandsController < Admin::GlobalSettings::ApplicationController
      before_action :authorize_user

      def togglevisible
        @brand = Brand.find(params[:id])
        @brand.toggle(:visible)
        @brand.save
        render 'admin/global_settings/brands/togglevisible.js.coffee'
      end

      def change_visible
        val = params[:invisible].presence ? false : true
        Brand.where({id: params[:brand_ids]}).update_all({visible: val})
        redirect_to :back
      end

      def sort
        Brand.sort(params[:brand])
        render :nothing => true
      end

      def index
        load_brands
      end

      def new
        build_brand
      end

      def create
        build_brand
        save_brand || render(:new)
      end

      def edit
        load_brand
        build_brand
      end

      def update
        load_brand
        build_brand
        save_brand || render(:edit)
      end

      def destroy
        load_brand
        @brand.destroy
        redirect_to [:admin, :global_settings, :brands]
      end

    private

      def load_brands
        @brands ||= brand_scope.to_a
      end

      def load_brand
        @brand ||= brand_scope.find(params[:id])
      end

      def brand_scope
        # TODO: make policy_scope work
        # policy_scope(Brand).all.order(:position)
        Brand.all.order(:position)
      end

      def build_brand
        @brand ||= brand_scope.build
        @brand.attributes = brand_params
      end

      def save_brand
        apply_redirect if @brand.save
      end

      def apply_redirect(notice = '')
        if params[:apply].present?
          redirect_to [:edit, :admin, :global_settings, @brand], notice: notice
        else
          redirect_to [:admin, :global_settings, :brands], notice: notice
        end
      end

      def authorize_user
        authorize :user, :user_has_rights?
      end

      def brand_params
        return {} if params[:brand].blank?
        params.require(:brand).permit(:title, :visible, :description, :image, :hover_image, :select_image)
      end
    end
  end
end
