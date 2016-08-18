Spree::Shipment.class_eval do
  has_many :designer_labels, through: :inventory_units

  include Nelou::ContainsDesigner

  def total
    item_cost + cost
  end

  def enterprise_order
    @enterprise_order ||= Enterprise::Order.find(enterprise_id, params: {partner_id: order.user.enterprise_partner_id})
  end
end
