module Spree
  class UserMailerPreview < ActionMailer::Preview

    def reset_password_instructions
      Spree::UserMailer.reset_password_instructions(User.last, 'faketoken')
    end

    def confirmation_instructions
      Spree::UserMailer.confirmation_instructions(User.last, 'faketoken')
    end
    
  end
end
