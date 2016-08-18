module Nelou
  class OrderMailer < Spree::BaseMailer
    def notification_mail(order)
      @order = order.respond_to?(:id) ? order : Spree::Order.find(order)

      mail to: 'mail@nelou.com', from: from_address, subject: Spree.t(:new_order)
    end
  end
end
