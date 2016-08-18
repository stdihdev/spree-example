Spree::UserMailer.class_eval do
  def reset_password_instructions(user, token, *_args)
    @user = user
    @edit_password_reset_url = spree.edit_spree_user_password_url(reset_password_token: token)

    mail to: user.email, from: from_address, subject: I18n.t(:subject, scope: [:devise, :mailer, :reset_password_instructions])
  end

  def confirmation_instructions(user, token, _opts = {})
    @user = user
    @confirmation_url = spree.spree_user_confirmation_url(confirmation_token: token)

    mail to: user.email, from: from_address, subject: I18n.t(:subject, scope: [:devise, :mailer, :welcome])
  end
end
