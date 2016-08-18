require 'rails_helper'

RSpec.feature 'User Login', type: :feature do
  before do
    page.driver.header 'Accept-Language', locale
    I18n.locale = locale
  end

  [:en, :de].each do |locale|

    context "when the user has set their locale to #{locale}" do
      let!(:store) { create :store }
      let(:user) { create :user }
      let(:locale) { locale }

      scenario 'user should be able to get a new confirmation token' do

        reset_mailer

        visit spree.new_spree_user_confirmation_path
        fill_in 'spree_user[email]', with: user.email
        click_button Spree.t(:resend_confirmation_instructions)

        within('body') do
          expect(page).to have_content I18n.t('devise.confirmations.send_instructions')
        end

        expect(unread_emails_for(user.email).size).to be >= parse_email_count(1)

        email = open_email(user.email)
        expect(email.body).to be

        click_email_link_matching(/confirmation_token=/i)

        within('body') do
          expect(page).to have_content I18n.t('devise.confirmations.confirmed')
        end

        fill_in 'spree_user[login]', with: user.email
        fill_in 'spree_user[password]', with: user.password
        click_button Spree.t(:login)

        within('body') do
          expect(page).to have_content Spree.t(:logged_in_succesfully)
        end

      end

    end

  end

end
