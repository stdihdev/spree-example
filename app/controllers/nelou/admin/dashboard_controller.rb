module Nelou
  module Admin
    class DashboardController < Spree::Admin::BaseController

      before_action :load_orders, only: [:index]
      before_action :load_products, only: [:index]

      def index
      end

      private

      def load_orders
        if spree_current_user.admin?
          @orders = Spree::Order.complete
        elsif spree_current_user.designer?
          @orders = Spree::Order.complete.containing_designer(spree_current_user.designer_label)
        end

        @orders = @orders.order(created_at: :desc).uniq
      end

      def load_products
        if spree_current_user.admin?
          @products = Spree::Product.all
        elsif spree_current_user.designer?
          @products = spree_current_user.designer_label.products
        end

        @products = @products.order(created_at: :desc).uniq
      end

    end
  end
end
