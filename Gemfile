source 'https://rubygems.org'

gem 'rails', '4.2.6'
# gem 'therubyracer', platforms: :ruby
gem 'activeresource_redirect_connection', github: 'sternzeit/activeresource_redirect_connection', tag: 'v0.0.2'
gem 'activeresource', '4.1.0'
gem 'acts_as_list', '0.7.4' # Fix a problem with spree models
gem 'bcrypt', '3.1.11'
gem 'bourbon', '4.2.6'
gem 'bxslider-rails', '4.2.5.1'
gem 'combine_pdf', '0.2.30'
gem 'countries', '1.2.5'
gem 'country_select', '2.5.2'
gem 'date_validator', '0.9.0'
gem 'eu_central_bank', github: 'RubyMoney/eu_central_bank'
gem 'exception_notification', '4.1.4'
gem 'font-awesome-rails', '4.6.1.0'
gem 'git'
gem 'globalize', '5.0.1'
gem 'haml-rails', '0.9.0'
gem 'http_accept_language', '2.0.5'
gem 'image_optim_pack', '0.2.1.20160413'
gem 'iso_country_codes', '0.7.4'
gem 'jbuilder', '2.4.1'
gem 'jquery-rails', '4.1.1'
gem 'mailchimp-api', '2.0.6', require: 'mailchimp'
gem 'mysql2', '0.4.2'
gem 'neat', '1.7.4'
gem 'paperclip-optimizer', '2.0.0'
gem 'paperclip', '4.2.4'
gem 'pg', '0.18.4'
gem 'rails-i18n', '4.0.8'
gem 'recaptcha', '1.3.0'
gem 'sass-rails', '5.0.4'
gem 'sidekiq-status', '0.6.0'
gem 'sidekiq', '4.1.1'
gem 'sinatra', '1.4.7', :require => false # For Sidekiq Web interface
gem 'social-buttons', '0.3.9'
gem 'turbolinks', '2.5.3'
gem 'uglifier', '3.0.0'

# Spree deps - DO NOT change order!
gem 'spree', '3.0.8'
gem 'spree_i18n', github: 'spree-contrib/spree_i18n', branch: '3-0-stable'
gem 'spree_auth_devise', github: 'spree/spree_auth_devise', branch: '3-0-stable'
gem 'spree_gateway', github: 'spree/spree_gateway', branch: '3-0-stable'
gem 'spree_address_book', github: 'romul/spree_address_book', branch: '3-0-stable'
gem 'spree_wishlist', github: 'spree-contrib/spree_wishlist', branch: '3-0-stable'
# gem 'spree_email_to_friend', github: 'spree-contrib/spree_email_to_friend', branch: '3-0-stable'
gem 'spree_print_invoice', github: 'spree-contrib/spree_print_invoice', branch: '3-0-stable'
gem 'spree_contact_us', github: 'spree-contrib/spree_contact_us', branch: '3-0-stable'
gem 'spree_multi_currency', github: 'scan/spree_multi_currency', branch: '3-0-stable' # Use scan's patch for namespaced links
# gem 'spree_chimpy', github: 'DynamoMTL/spree_chimpy', branch: '3-stable'
gem 'spree_paypal_express', github: 'spree-contrib/better_spree_paypal_express', branch: '3-0-stable'
# gem 'spree_static_content', github: 'spree-contrib/spree_static_content', branch: '3-0-stable'

group :production, :staging do
  gem 'unicorn', '5.0.1'
  gem 'slack-notifier', '1.5.1'
end

group :development do
  # gem 'capistrano-spree', '1.0.3', require: false
  gem 'capistrano-bundler', '1.1.4', require: false
  gem 'capistrano-rails', '1.1.6', require: false
  gem 'capistrano-rvm', '0.1.2', require: false
  gem 'capistrano-sidekiq', '0.5.4', require: false
  gem 'capistrano', '3.4.0'
  gem 'capistrano3-unicorn', '0.2.1', require: false
  gem 'html2haml', '2.0.0'
  gem 'quiet_assets', '1.1.0'
  gem 'spring', '1.7.1'
  gem 'thin', '1.6.4'
  gem 'web-console', '3.1.1'
  gem 'webmock'
end

group :development, :test do
  gem 'byebug', '8.2.4'
  gem 'factory_girl_rails', '4.7.0'
  gem 'ffaker', '1.32.1'
  gem 'rspec-rails', '3.4.2'
end

group :test do
  gem 'capybara', '2.7.0'
  gem 'email_spec', '2.0.0'
  gem 'database_cleaner', '1.5.1'
end

group :doc do
  gem 'sdoc', '0.4.1'
end
