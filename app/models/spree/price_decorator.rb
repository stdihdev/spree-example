Spree::Price.class_eval do
  include Nelou::Price::Sales

  # Has to be defined here, otherwise endless recursion!
  def price
    on_sale? ? sale_price : original_price
  end

  # Has to be defined here, otherwise endless recursion!
  def amount
    price
  end

  def display_html
    Spree::Money.new(amount, currency: currency).to_html
  end
end
