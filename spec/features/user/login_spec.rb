require 'rails_helper'

RSpec.feature 'User Login', type: :feature do
  before do
    page.driver.header 'Accept-Language', locale
    I18n.locale = locale
  end

  [:en, :de].each do |locale|

    context "when the user has set their locale to #{locale}" do
      let!(:store) { create :store }
      let(:user) { create :confirmed_user }
      let(:locale) { locale }

      scenario 'user should be able to login' do

        reset_mailer

        visit spree.login_path

        fill_in 'spree_user[login]', with: user.email
        fill_in 'spree_user[password]', with: user.password
        click_button Spree.t(:login)

        within('body') do
          expect(page).to have_content Spree.t(:logged_in_succesfully)
        end

      end

      scenario 'user should not be able to login with a wrong password' do

        reset_mailer

        visit spree.login_path

        fill_in 'spree_user[login]', with: user.email
        fill_in 'spree_user[password]', with: SecureRandom.hex
        click_button Spree.t(:login)

        within('body') do
          expect(page).not_to have_content Spree.t(:logged_in_succesfully)
        end

      end

      scenario 'user should not be able to login with a wrong email' do

        reset_mailer

        visit spree.login_path

        fill_in 'spree_user[login]', with: SecureRandom.hex
        fill_in 'spree_user[password]', with: user.password
        click_button Spree.t(:login)

        within('body') do
          expect(page).not_to have_content Spree.t(:logged_in_succesfully)
        end

      end

    end

  end

end
