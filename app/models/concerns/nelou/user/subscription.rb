module Nelou
  module User
    module Subscription

      extend ActiveSupport::Concern

      included do
        after_commit :subscribe, on: :create
        after_commit :unsubscribe, on: :destroy
      end

      def is_subscribed?
        # TODO: Figure out how to invalidate after subscribe
        Rails.cache.fetch("#{cache_key}/is_subscribed", expires_in: 1.minute) do
          Nelou::SubscriptionService.new.is_subscribed?(email)
        end
      end

      private

      def subscribe
        Nelou::Mailchimp::SubscribeUserJob.perform_later id
      end

      def unsubscribe
        Nelou::Mailchimp::UnsubscribeUserJob.perform_later id
      end

    end
  end
end
