class Enterprise::OrderService

  def initialize(order)
    @order = order
  end

  def create!
    @order.shipments.each do |shipment|
      next if shipment.enterprise_id.present?

      check_for_user_bill_address!

      begin
        order = Enterprise::Order.new_from(shipment)
        order.prefix_options[:partner_id] = @order.user.enterprise_partner_id
        order.save!

        shipment.enterprise_id = order.id
        shipment.update_attribute :enterprise_id, order.id
      rescue => e
        ExceptionNotifier.notify_exception(e)
        Rails.logger.error e.to_s
        Rails.logger.error e.backtrace.join("\n")
      end
    end

    @order.update_attribute :sent_to_enterprise, true if @order.shipments.count == @order.shipments.where.not(enterprise_id: nil).count
  end

  def save!
    return if Rails.application.secrets.skip_enterprise
    create!
  end

  private

  def check_for_user_bill_address!
    return if @order.user.enterprise_contact_id.present?

    user = @order.user
    user.bill_address = @order.bill_address unless user.bill_address.present?
    user.save!(validate: false)
  end

end
