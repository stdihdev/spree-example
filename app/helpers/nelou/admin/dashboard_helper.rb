module Nelou
  module Admin
    module DashboardHelper

      def short_product_list(order)

        if spree_current_user.designer?
          line_items = order.line_items.by_designer(spree_current_user.designer_label)
        else
          line_items = order.line_items
        end

        line_items.map(&:name).sort.uniq.join(', ')

      end

      def unshipped_orders_count(orders)

        if spree_current_user.designer?
          orders.with_open_shipments_from_designer(spree_current_user.designer_label).count
        else
          orders.with_open_shipments.count
        end

      end

    end
  end
end
