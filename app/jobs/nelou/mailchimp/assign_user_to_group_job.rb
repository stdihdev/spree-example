class Nelou::Mailchimp::AssignUserToGroupJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    user_id = args.first

    user = Spree::User.find_by(id: user_id)

    return unless user.present?
    return unless user.designer? && user.designer_label.present?

    if user.designer_label.active && user.designer_label.accepted
      Nelou::SubscriptionService.new.add_to_active_designers! user.email
    else
      Nelou::SubscriptionService.new.remove_from_active_designers! user.email
    end

  rescue => e
    ExceptionNotifier.notify_exception(e)

    Rails.logger.error e.to_s
    Rails.logger.error e.backtrace.join "\n"
  end

end
