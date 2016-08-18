module Nelou
  module Calculator
    class PercentOffSalePriceCalculator < Spree::Calculator

      def self.description
        "Calculates the sale price for a Variant by taking off a percentage of the original price"
      end

      def compute(sale_price)
        (1.0 - sale_price.value.to_f) * sale_price.variant.original_price.to_f
      end

    end
  end
end
