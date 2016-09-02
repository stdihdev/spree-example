Spree::Variant.class_eval do
  has_one :designer_label, through: :product
  has_many :option_types, through: :option_values

  include Nelou::Variant::Sales
  include Nelou::Variant::LimitedItems

  attr_accessor :validate_option_values
  validate :every_option_type_has_a_value, if: :validate_option_values?

  def primary_option_type
    @primary_option_type ||= option_types.to_a.reject { |o| o.is_a?(Nelou::SizeOptionType) }.first
  end

  def primary_option_value
    @primary_option_value ||= option_values.find { |v| v.option_type == primary_option_type }
  end

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

  def validate_option_values?
    validate_option_values == '1' || validate_option_values == true
  end

  def has_different_price?
    price != product.master.price
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

  def every_option_type_has_a_value
    product.option_types.each do |option_type|
      if option_values.none? { |option_value| option_value.option_type_id == option_type.id }
        errors.add(:option_values, I18n.t('variant.errors.required_value_for_option', option_type: option_type.name))
      end
    end
  end
end
