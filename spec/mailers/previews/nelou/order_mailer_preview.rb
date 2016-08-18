module Nelou
  class OrderMailerPreview < ActionMailer::Preview

    def notification_mail
      Nelou::OrderMailer.notification_mail(Spree::Order.complete.last)
    end
    
  end
end
