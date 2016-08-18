Spree::Variant.class_eval do
  has_one :designer_label, through: :product

  include Nelou::Variant::Sales
  include Nelou::Variant::LimitedItems

  # Override to prevent
  def self.active(currency = nil)
    where(deleted_at: nil)
  end

  def designer_label_id
    if designer_label.nil?
      nil
    else
      designer_label.id
    end
  end

  def price_in(currency)
    prices.detect { |price| price.currency == currency } || converted_price_in(currency)
  end

  private

  def converted_price_in(currency, base_price = nil)
    base_price ||= default_price

    if base_price.respond_to?(:money)
      conv = Nelou::Exchange::Rates.exchange_with(base_price.money.money, currency)
    else
      conv = Nelou::Exchange::Rates.exchange_with(::Money.new(base_price * 100, default_price.currency), currency) # TODO: Find more elegant solution
    end

    Spree::Price.new(variant_id: id, currency: conv.currency, amount: conv.amount)
  end
end
