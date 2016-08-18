module Nelou
  module Admin
    class DesignersController < Spree::Admin::UsersController

      before_action :load_users, only: [ :index ]

      # Has to be overridden because they do not use build_resource and provide no hooks
      def create
        @user = Spree.user_class.new(user_params)

        @user.skip_confirmation!
        @user.spree_roles << Spree::Role.designer_role

        if @user.save
          set_roles

          flash.now[:success] = flash_message_for(@user, :successfully_created)
          redirect_to spree.edit_admin_user_path(@user)
        else
          render :new
        end
      end

      protected

      def object_name
        :user
      end

      def load_users
        @users = @collection.order('last_sign_in_at DESC NULLS LAST') # NULLS LAST only works wiht PSQL
      end

      def build_resource
        obj = super

        if obj.kind_of? Spree::User
          obj.spree_roles << Spree::Role.designer_role
          obj.build_designer_label
        end

        obj
      end

      # Add filter for designer products
      # Unfortunately, `super` does not work here, hence alias_method
      alias_method :orig_collection, :collection
      def collection
        orig_collection.designers
      end
    end
  end
end
