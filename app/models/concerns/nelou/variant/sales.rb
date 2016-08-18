module Nelou
  module Variant
    module Sales
      extend ActiveSupport::Concern

      included do
        delegate_belongs_to :default_price, :sale_price, :original_price
      end

      def put_on_sale(value, calculator_type = 'Nelou::Calculator::AmountSalePriceCalculator', all_currencies = true, start_at = Time.now, end_at = nil, enabled = true)
        run_on_prices(all_currencies) { |p| p.put_on_sale value, calculator_type, start_at, end_at, enabled }
      end
      alias create_sale put_on_sale

      def active_sale_in(currency)
        price_in(currency).active_sale
      end
      alias current_sale_in active_sale_in

      def next_active_sale_in(currency)
        price_in(currency).next_active_sale
      end
      alias next_current_sale_in next_active_sale_in

      def sale_price_in(currency)
        if has_price_in?(currency)
          Spree::Price.new variant_id: id, currency: currency, amount: price_in(currency).sale_price
        else
          converted_price_in(currency, default_price.sale_price)
        end
      end

      def original_price_in(currency)
        if has_price_in?(currency)
          Spree::Price.new variant_id: id, currency: currency, amount: price_in(currency).original_price
        else
          converted_price_in(currency, default_price.original_price)
        end
      end

      def discount_percent_in(currency)
        if has_price_in?(currency)
          price_in(currency).discount_percent
        else
          (1 - (sale_price_in(currency).amount / original_price_in(currency).amount)) * 100
        end
      end

      def on_sale_in?(_currency)
        on_sale?
      end

      def on_sale?
        default_price.on_sale?
      end

      def enable_sale(all_currencies = true)
        run_on_prices(all_currencies, &:enable_sale)
      end

      def disable_sale(all_currencies = true)
        run_on_prices(all_currencies, &:disable_sale)
      end

      def start_sale(end_time = nil, all_currencies = true)
        run_on_prices(all_currencies) { |p| p.start_sale end_time }
      end

      def stop_sale(all_currencies = true)
        run_on_prices(all_currencies, &:stop_sale)
      end

      private

      def run_on_prices(all_currencies)
        if all_currencies && prices.present?
          prices.each { |p| yield p }
        else
          yield default_price
        end
      end

      def has_price_in?(currency)
        prices.find { |price| price.currency == currency }.present?
      end
    end
  end
end
