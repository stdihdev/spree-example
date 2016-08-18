module Nelou
  class DesignerMailer < Spree::BaseMailer

    def self.notification_mails(order)
      order = order.respond_to?(:id) ? order : Spree::Order.find(order)

      order.designer_labels.uniq.each do |designer_label|
        if designer_label.user.present?
          notification_mail(order, designer_label).deliver_later
        end
      end
    end

    def notification_mail(order, designer_label)
      @order = order
      @designer_label = designer_label
      @products = order.products.by_designer(designer_label)

      mail(to: designer_label.user.email, from: from_address, subject: Spree.t(:new_order_from_customer))
    end

  end
end
