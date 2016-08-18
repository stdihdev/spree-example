module Nelou
  module Admin
    class WishlistsController < Spree::Admin::ResourceController
      before_action :load_user, only: [ :show ]

      protected

      def model_class
        Spree::Wishlist
      end

      def object_name
        :spree_wishlist
      end

      def collection_url
        main_app.admin_nelou_wishlists_url
      end

      def find_resource
        model_class.find_by(access_hash: params[:id])
      end

      def collection
        return @collection if @collection

        params[:q] ||= {}

        @search = Spree::Wishlist.ransack(params[:q])

        @collection = @search.result(distinct: true)
          .joins(:wished_products)
          .includes(:user, :wished_products)
          .page(params[:page])

        @collection
      end

      def load_user
        @user = @object.user
      end

    end
  end
end
