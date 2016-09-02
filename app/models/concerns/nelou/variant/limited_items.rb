module Nelou
  module Variant
    module LimitedItems
      extend ActiveSupport::Concern

      included do
        validates :limited_items, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
        validates :limited_items_sold, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
        validates :limited_items, presence: true, if: :limited?
        validates :limited_items_sold, numericality: { less_than_or_equal_to: :limited_items }, if: :limited?

        after_save :set_sold_out_on_product
      end

      def limited?
        limited
      end

      def limited_items_available
        if limited_items.nil? || (limited_items_sold || 0) > limited_items
          0
        else
          limited_items - (limited_items_sold || 0)
        end
      end

      def can_supply?
        !limited? || ((limited_items_sold || 0) <= limited_items)
      end

      def sold_out?
        not can_supply?
      end

      def set_limited
        self.limited = true
      end

      private

      def set_sold_out_on_product
        self.product.update_columns( sold_out: self.product.not_in_stock?, updated_at: Time.now )
      end
    end
  end
end
