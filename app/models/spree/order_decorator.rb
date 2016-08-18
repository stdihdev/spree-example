Spree::Order.class_eval do
  has_many :designer_labels, through: :products

  include Nelou::ContainsDesigner

  scope :with_open_shipments, -> { joins(:shipments).where("#{Spree::Shipment.quoted_table_name}.state": %w(ready partial)).uniq }

  state_machine.after_transition to: :complete, do: :increment_limited_items_counter
  state_machine.after_transition to: :complete, do: :persist_with_enterprise

  self.whitelisted_ransackable_associations = %w[shipments user promotions bill_address ship_address line_items products designer_labels]

  alias_method :orig_deliver_order_confirmation_email, :deliver_order_confirmation_email

  def deliver_order_confirmation_email
    orig_deliver_order_confirmation_email
    Nelou::DesignerMailer.notification_mails(id)
    Nelou::OrderMailer.notification_mail(id).deliver_later
  end

  # Do not generate random order numbers
  def generate_number(options = {})
    options[:length]  ||= Spree::NumberGenerator::NUMBER_LENGTH
    self.number = "%s%04i" % [Time.now.strftime("%y%m%d"), Random.rand(0..9_999)]
  end

  def price_from_line_item(line_item)
    line_item.variant.price_in(currency)
  end

  def available_payment_methods
    @available_payment_methods ||= (Spree::PaymentMethod.available(:front_end) + Spree::PaymentMethod.available(:both)).uniq.sort { |a,b| a.name <=> b.name }
  end

  def self.with_open_shipments_from_designer(designer_label)
    joins(shipments: :designer_labels)
      .merge(Spree::Shipment.containing_designer(designer_label))
      .where("#{Spree::Shipment.quoted_table_name}.state": %w(ready partial))
      .uniq
  end

  def display_item_total_for_designer(designer_label)
    Spree::Money.new(line_items.by_designer(designer_label).map(&:total).sum, currency: currency)
  end

  def display_ship_total_for_designer(designer_label)
    Spree::Money.new(shipments.containing_designer(designer_label).map(&:cost).sum, currency: currency)
  end

  def display_total_for_designer(designer_label)
    Spree::Money.new([display_item_total_for_designer(designer_label).money.amount, display_ship_total_for_designer(designer_label).money.amount].sum, currency: currency)
  end

  private

  def increment_limited_items_counter
    line_items.each do |line_item|
      variant = line_item.variant
      variant.limited_items_sold += line_item.quantity
      Spree::Variant.update variant.id, limited_items_sold: variant.limited_items_sold
    end
  end

  def persist_with_enterprise
    Nelou::CreateOrderInvoiceJob.perform_later(self.id)
  end
end
