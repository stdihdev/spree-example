module Spree
  class ReimbursementMailerPreview < ActionMailer::Preview

    def reimbursement_email
      Spree::ReimbursementMailer.reimbursement_email(Spree::Reimbursement.last)
    end

  end
end
