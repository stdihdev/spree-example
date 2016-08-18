module Nelou
  module SubscriptionHelper

    def mailchimp_user_id
      Rails.application.secrets.mailchimp_user_id
    end

    def mailchimp_mailing_list_id
      Rails.application.secrets.mailchimp_list
    end

    def mailchimp_form_base
      Rails.application.secrets.mailchimp_form_base
    end

  end
end
