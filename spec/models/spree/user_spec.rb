require 'rails_helper'

RSpec.describe Spree::User, type: :model do
  let!(:store) { create :store }
  let(:user) { create :user }
  let(:designer) { create :designer }

  it 'has a valid factory' do
    expect(user).to be_valid
  end

  it 'validates new user password' do
    user.valid_password? 'password'
  end

  it 'fails to validate wrong user password' do
    expect(user.valid_password? 'not the password').to be(false)
  end

  it 'has a designer_label upon creation' do
    expect(designer.designer_label).to be_valid
  end
end
