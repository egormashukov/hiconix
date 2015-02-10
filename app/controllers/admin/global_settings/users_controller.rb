module Admin
  module GlobalSettings
    class UsersController < Admin::GlobalSettings::ApplicationController
      before_action :authorize_user#, except: [:index]

      def index
        load_users
      end

      def new
        build_user
      end

      def create
        build_user
        save_user || render(:new)
      end

      def edit
        load_user
        build_user
      end

      def update
        load_user
        build_user
        save_user || render(:edit)
      end

      def destroy
        load_user
        @user.destroy
        redirect_to [:admin, :global_settings, :users]
      end

      private

      def load_users
        @users ||= user_scope.to_a
      end

      def load_user
        @user ||= user_scope.find(params[:id])
      end

      def user_scope
        policy_scope(User).all
      end

      def build_user
        @user ||= user_scope.build
        @user.attributes = user_params
      end

      def save_user
        apply_redirect if @user.save
      end

      def apply_redirect(notice = '')
        if params[:apply].present?
          redirect_to [:edit, :admin, :global_settings, @user], notice: notice
        else
          redirect_to [:admin, :global_settings, :users], notice: notice
        end
      end

      def authorize_user
        authorize :user, :user_has_rights?
      end

      def user_params
        return {} if params[:user].blank?
        params.require(:user).permit(
          :name, :email, :password, :password_confirmation,
          :authorization_profile_id
        )
      end
    end
  end
end
