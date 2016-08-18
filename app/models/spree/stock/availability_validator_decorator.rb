Spree::Stock::AvailabilityValidator.class_eval do
  def validate(line_item)
    unit_count = line_item.inventory_units.size
    return if unit_count >= line_item.quantity

    quantity = line_item.quantity - unit_count
    return if quantity.zero?

    return if item_available?(line_item, quantity)

    variant = line_item.variant
    display_name = variant.name.to_s
    display_name += " (#{variant.options_text})" unless variant.options_text.blank?

    line_item.quantity = variant.limited_items_available if variant.limited? && variant.limited_items_available && line_item.quantity > variant.limited_items_available

    line_item.errors[:quantity] << Spree.t(
      :selected_quantity_not_available,
      item: display_name.inspect
    )
  end

end
