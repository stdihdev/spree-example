module Nelou
  module Admin
    class SalesController < Spree::Admin::BaseController
      before_action :load_product
      before_action :authorize_product
      before_action :redirect_if_already_on_sale, only: [:new, :create]
      before_action :redirect_if_not_on_sale, only: [:cancel]

      def index
      end

      def new
        @sale = Nelou::Sale.new
      end

      def create
        @sale = Nelou::Sale.new(sale_params)
        if @sale.validate
          @product.put_on_sale(@sale.amount, @sale.calculator_type, true, @sale.start_at, @sale.end_at)
          redirect_to admin_nelou_sales_path(@product)
        else
          render :new
        end
      end

      def cancel
        @product.stop_sale
        redirect_to admin_nelou_sales_path(@product)
      end

      private

      def sale_params
        params.require(:nelou_sale).permit(:start_at, :end_at, :calculator_type, :amount)
      end

      def load_product
        @product = Spree::Product.with_deleted.friendly.find params[:product_id]
      end

      def authorize_product
        authorize! :sales, @product
      end

      def redirect_if_already_on_sale
        if @product.on_sale?
          redirect_to admin_nelou_sales_path(@product)
        end
      end

      def redirect_if_not_on_sale
        unless @product.on_sale?
          redirect_to admin_nelou_sales_path(@product)
        end
      end
    end
  end
end
