class Enterprise::Contact < Enterprise::Base
  self.site = Rails.application.secrets.enterprise_api_url + '/customers/:partner_id/'
end
