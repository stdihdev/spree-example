module Nelou
  class DesignerMailerPreview < ActionMailer::Preview

    def notification_mail
      order = Spree::Order.complete.last
      Nelou::DesignerMailer.notification_mail(order, order.designer_labels.last)
    end

  end
end
