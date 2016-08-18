require 'rails_helper'

RSpec.describe Nelou::Admin::DesignersController, type: :controller do
  let!(:store) { create :store }
  let(:admin) { create :admin }
  let(:designer) { create :designer }
  let(:customer) { create :confirmed_user }

  # The Spree Controller Helper overrides the default router, we have to set it to the main-app router again
  # TODO: Find more elegant solution
  routes { Rails.application.routes }

  describe 'GET #index' do

    context 'when user has no role' do

      before(:each) do
        sign_in :spree_user, customer
      end

      it 'redirects to unauthorized' do
        get :index

        expect(response).to redirect_to(spree.admin_unauthorized_path)
      end

    end

    context 'when user is a designer' do

      before(:each) do
        sign_in :spree_user, designer
      end

      it 'redirects to unauthorized' do
        get :index

        expect(response).to redirect_to(spree.admin_unauthorized_path)
      end

    end

    context 'when user is admin' do

      before(:each) do
        sign_in :spree_user, admin
      end

      it 'renders the right template' do
        get :index

        expect(response).to render_template(:index)
      end

    end

  end

  describe 'GET #new' do

    context 'when user has no role' do

      before(:each) do
        sign_in :spree_user, customer
      end

      it 'redirects to unauthorized' do
        get :new

        expect(response).to redirect_to(spree.admin_unauthorized_path)
      end

    end

    context 'when user is a designer' do

      before(:each) do
        sign_in :spree_user, designer
      end

      it 'redirects to unauthorized' do
        get :new

        expect(response).to redirect_to(spree.admin_unauthorized_path)
      end

    end

    context 'when user is admin' do

      before(:each) do
        sign_in :spree_user, admin
      end

      it 'renders the right template' do
        get :new

        expect(response).to render_template(:new)
      end

    end

  end

  describe 'POST #create' do

    let(:password) { Faker::Internet.password }
    let(:attributes) do
      {
        email: Faker::Internet.email,
        password: password,
        password_confirmation: password,
        designer_label_attributes: {
          name: Faker::Name.name
        }
      }
    end

    context 'when user has no role' do

      before(:each) do
        sign_in :spree_user, customer
      end

      it 'redirects to unauthorized' do
        post :create, user: attributes

        expect(response).to redirect_to(spree.admin_unauthorized_path)
      end

    end

    context 'when user is a designer' do

      before(:each) do
        sign_in :spree_user, designer
      end

      it 'redirects to unauthorized' do
        post :create, user: attributes

        expect(response).to redirect_to(spree.admin_unauthorized_path)
      end

    end

    context 'when user is admin' do

      before(:each) do
        sign_in :spree_user, admin
      end

      it 'created a new user' do
        count = Spree::User.count

        post :create, user: attributes

        expect(Spree::User.count).to eq(count + 1)
      end

      it 'creates a new user who is a designer' do
        post :create, user: attributes

        user = Spree::User.last

        expect(user.designer?).to be_truthy
        expect(user.designer_label).to be_valid
      end

      it 'creates a new user with the right attribues' do
        post :create, user: attributes

        user = Spree::User.last

        expect(user.email).to eq(attributes[:email])
        expect(user.designer_label).to be_valid
        expect(user.designer_label.name).to eq(attributes[:designer_label_attributes][:name])
      end

      it 'redirects to editing page' do
        post :create, user: attributes

        user = Spree::User.last

        expect(response).to redirect_to(spree.edit_admin_user_path(user))
      end

    end

  end
end
