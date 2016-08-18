class Enterprise::Order < Enterprise::Base
  self.site = Rails.application.secrets.enterprise_api_url + '/customers/:partner_id/'

  # before_save :debug_output

  def self.new_from(shipment)
    order = shipment.order
    designer_label = shipment.designer_labels.first

    Enterprise::Order.new({
      reseller_id: Rails.application.secrets.enterprise_default_reseller,
      with_invoice: true,
      external_identifier: order.number,
      paid: true,
      payment_method: order.payments.valid.first.try(:payment_method).try(:name).try(:parameterize),
      price_mode: 'gross',
      currency: order.currency,
      start_date: order.completed_at.to_date,
      end_date: order.completed_at.to_date,
      totalamount: shipment.total,
      language: I18n.locale.to_s,
      text: Spree.t(:your_order_from, designer: designer_label.name, number: order.number),
      address_id: order.bill_address.try(:enterprise_id),
      items: get_items_from_order(shipment)
    })
  end

  private

  def self.get_items_from_order(shipment)
    designer_label = shipment.designer_labels.first

    items = shipment.line_items.map do |line_item|
      {
        unit: 1,
        quantity: BigDecimal.new(line_item.quantity, 0),
        price: line_item.variant.price,
        product: {
          name: line_item.product.name,
          description: line_item.variant.options_text,
          price: line_item.variant.price,
          publisher_id: designer_label.user.enterprise_partner_id
        }
      }
    end

    items << {
      unit: 1,
      quantity: BigDecimal.new(1, 0),
      price: shipment.cost,
      product: {
        name: Spree.t(:shipping),
        description: '',
        price: shipment.cost,
        publisher_id: designer_label.user.enterprise_partner_id
      }
    }

    items
  end

  def debug_output
    puts self.to_xml
  end

end
