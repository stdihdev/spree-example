module Nelou
  class SubscriptionsController < Spree::StoreController

    def unsubscribe
      if spree_current_user.present?
        Nelou::SubscriptionService.new.unsubscribe!(spree_current_user.email)
        Rails.cache.delete("#{spree_current_user.cache_key}/is_subscribed")

        redirect_to spree.account_path
      else
        redirect_to root_path
      end
    end

  end
end
