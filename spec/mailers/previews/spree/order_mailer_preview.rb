module Spree
  class OrderMailerPreview < ActionMailer::Preview
    def confirm_email
      Spree::OrderMailer.confirm_email(Spree::Order.complete.last)
    end

    def cancel_email
      Spree::OrderMailer.cancel_email(Spree::Order.complete.last)
    end
  end
end
