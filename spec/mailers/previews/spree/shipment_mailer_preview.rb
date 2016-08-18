module Spree
  class ShipmentMailerPreview < ActionMailer::Preview
    def shipped_email
      Spree::ShipmentMailer.shipped_email(Spree::Order.complete.last.shipments.first)
    end
  end
end
