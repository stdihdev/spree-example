module Nelou
  class SubscriptionService

    #[{"id"=>5737, "name"=>"Receiver Type", "form_field"=>"hidden", "display_order"=>"0", "groups"=>[{"id"=>19649, "bit"=>"1", "name"=>"Customers", "display_order"=>"1", "subscribers"=>nil}, {"id"=>19653, "bit"=>"2", "name"=>"Subscribers", "display_order"=>"2", "subscribers"=>nil}, {"id"=>19657, "bit"=>"4", "name"=>"Designer", "display_order"=>"3", "subscribers"=>nil}, {"id"=>19661, "bit"=>"8", "name"=>"Press and Blogs", "display_order"=>"4", "subscribers"=>nil}]}]

    def initialize
      @mailchimp = ::Mailchimp::API.new(Rails.application.secrets.mailchimp_api_key)
      @list_id = Rails.application.secrets.mailchimp_list
    end

    def subscribe!(email, locale = 'de', designer = false)
      language = locale.to_s.upcase

      groupings = nil

      if Rails.application.secrets.mailchimp_groupings_id.present?
        groups = [ Rails.application.secrets.mailchimp_customer_group_name ]
        groups = [ Rails.application.secrets.mailchimp_designer_group_name ] if designer

        groupings = [{
          id: Rails.application.secrets.mailchimp_groupings_id, groups: groups
        }]
      end

      # @see http://www.rubydoc.info/gems/mailchimp-api/2.0.4/Mailchimp%2FLists%3Asubscribe
      @mailchimp.lists.subscribe @list_id, { email: email }, {
        LANGUAGE: language,
        mc_language: locale.to_s.downcase,
        groupings: groupings
      }, 'html', false, true, true, false
    end

    def unsubscribe!(email)
      # @see http://www.rubydoc.info/gems/mailchimp-api/2.0.4/Mailchimp%2FLists%3Aunsubscribe
      @mailchimp.lists.unsubscribe @list_id, { email: email }
    end

    def is_subscribed?(email)
      info = @mailchimp.lists.member_info @list_id, [{ email: email }]

      if info['success_count'] > 0
        data = info['data'].first
        data.present? && data['status'] == 'subscribed'
      else
        false
      end
    rescue
      false
    end

    def is_unsubscribed?(email)
      info = @mailchimp.lists.member_info @list_id, [{ email: email }]

      if info['success_count'] > 0
        data = info['data'].first
        data.present? && data['status'] == 'unsubscribed'
      else
        false
      end
    rescue
      false
    end

    def is_on_list?(email)
      info = @mailchimp.lists.member_info @list_id, [{ email: email }]

      if info['success_count'] > 0
        data = info['data'].first
        if data.present?
          data
        else
          false
        end
      else
        false
      end
    rescue
      return false
    end

    def remove_from_active_designers!(email)
      return unless is_on_list?(email)

      @mailchimp.lists.update_member @list_id, { email: email }, {
        groupings: [{
          id: Rails.application.secrets.mailchimp_groupings_id,
          groups: [ Rails.application.secrets.mailchimp_designer_group_name ]
        }]
      }, '', true

      true
    rescue ::Mailchimp::ListNotSubscribedError
      return false
    end

    def add_to_active_designers!(email)
      return unless is_on_list?(email)

      @mailchimp.lists.update_member @list_id, { email: email }, {
        groupings: [{
          id: Rails.application.secrets.mailchimp_groupings_id,
          groups: [
            Rails.application.secrets.mailchimp_designer_group_name,
            Rails.application.secrets.mailchimp_active_designer_group_name
          ]
        }]
      }, '', true

      true
    rescue ::Mailchimp::ListNotSubscribedError
      return false
    end

  end
end
