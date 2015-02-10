module Admin
  module GlobalSettings
    class AuthorizationProfilesController < Admin::GlobalSettings::ApplicationController
      before_action :authorize_user

      def index
        load_profiles
      end

      def new
        build_profile
      end

      def create
        build_profile
        save_profile || render(:new)
      end

      def edit
        load_profile
        build_profile
      end

      def update
        load_profile
        build_profile
        save_profile || render(:edit)
      end

      def destroy
        load_profile
        @profile.destroy
        redirect_to [:admin, :global_settings, :authorization_profiles]
      end

      private

      def load_profiles
        @profiles ||= profile_scope.to_a
      end

      def load_profile
        @profile ||= profile_scope.find(params[:id])
      end

      def profile_scope
        AuthorizationProfile.all
      end

      def build_profile
        @profile ||= profile_scope.build
        @profile.attributes = profile_params
      end

      def save_profile
        apply_redirect if @profile.save
      end

      def authorize_user
        authorize :user, :user_has_rights?
      end

      def apply_redirect(notice = '')
        if params[:apply].present?
          redirect_to [:edit, :admin, :global_settings, @profile], notice: notice
        else
          redirect_to [:admin, :global_settings, :authorization_profiles], notice: notice
        end
      end

      def profile_params
        return {} if params[:authorization_profile].blank?
        params.require(:authorization_profile).permit(:title, policies: [])
      end
    end
  end
end
