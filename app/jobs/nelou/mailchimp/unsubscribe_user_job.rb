class Nelou::Mailchimp::UnsubscribeUserJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    user_id = args.first

    user = Spree::User.find_by(id: user_id)

    return unless user.present?

    if user.subscribed
      begin
        Nelou::SubscriptionService.new.unsubscribe! user.email
      rescue => e
        ExceptionNotifier.notify_exception(e)

        Rails.logger.error e.to_s
        Rails.logger.error e.backtrace.join "\n"
      end
    end

    user.update_column(:subscribed, false)
  end
end
