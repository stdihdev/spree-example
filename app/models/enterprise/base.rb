class Enterprise::Base < ActiveResource::Base
  self.site = Rails.application.secrets.enterprise_api_url
  self.headers['X-Api-Auth-Token'] = Rails.application.secrets.enterprise_api_token
  self.format = :xml
end
