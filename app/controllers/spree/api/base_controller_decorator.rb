Spree::Api::BaseController.class_eval do
  # Fixes API failures when using multi-currency
  # @see https://github.com/spree-contrib/spree_multi_currency/issues/42
  include Spree::CurrencyHelpers
  include Nelou::SetLocale
end
