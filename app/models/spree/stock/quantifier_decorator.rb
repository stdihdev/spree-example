Spree::Stock::Quantifier.class_eval do

  def backorderable?
    not @variant.limited?
  end

  def total_on_hand
    if @variant.limited?
      @variant.limited_items_available
    else
      Float::INFINITY
    end
  end
end
