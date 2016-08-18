module Nelou
  module Exchange
    class Rates
      def self.exchange_with(original, currency)
        update_rates!
        eu_bank.exchange_with(original, currency)
      end

      private

      def self.cache_path
        File.join(Rails.root, 'tmp', 'exchange_rates.xml')
      end

      def self.eu_bank
        @@eu_bank ||= EuCentralBank.new
      end

      def self.update_rates!
        if !eu_bank.rates_updated_at || eu_bank.rates_updated_at < Time.now - 1.days
          eu_bank.save_rates(cache_path)
          eu_bank.update_rates(cache_path)
        end
      end
    end
  end
end
