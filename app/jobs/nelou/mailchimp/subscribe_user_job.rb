class Nelou::Mailchimp::SubscribeUserJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    user_id = args.first

    user = Spree::User.find_by(id: user_id)

    return unless user.present?

    if user.subscribed
      Nelou::SubscriptionService.new.subscribe! user.email, user.locale, user.designer?

      user.update_column(:subscribed, true)
    end
  rescue => e
    ExceptionNotifier.notify_exception(e)
    Rails.logger.error e.to_s
    Rails.logger.error e.backtrace.join "\n"

    user.update_column(:subscribed, false) if user.present?
  end
end
