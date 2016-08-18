module Nelou
  class ApplicationMailer < Spree::BaseMailer

    def notification_mail(designer)
      mail(to: 'mail@nelou.com', from: from_address, subject: Spree.t(:new_designer_application)) do |format|
        format.text {
          render locals: { user: designer, designer_label: designer.designer_label }
        }
      end
    end

  end
end
