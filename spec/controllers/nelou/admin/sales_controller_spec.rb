require 'rails_helper'

RSpec.describe Nelou::Admin::SalesController, type: :controller do
  let!(:store) { create :store }
  let(:admin) { create :admin }
  let(:customer) { create :confirmed_user }
  let(:product) { create :product }
  let(:designer) { product.designer_label.user }

  # The Spree Controller Helper overrides the default router, we have to set it to the main-app router again
  # TODO: Find more elegant solution
  routes { Rails.application.routes }

  describe 'GET #index' do

    context 'when user has no role' do

      before(:each) do
        sign_in :spree_user, customer
      end

      it 'redirects to unauthorized' do
        get :index, product_id: product.id

        expect(response).to redirect_to(spree.unauthorized_path)
      end

    end

    context 'when user is a designer' do

      before(:each) do
        sign_in :spree_user, designer
      end

      it 'renders the right template' do
        get :index, product_id: product.id

        expect(response).to render_template(:index)
      end

    end

    context 'when user is admin' do

      before(:each) do
        sign_in :spree_user, admin
      end

      it 'renders the right template' do
        get :index, product_id: product.id

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
        get :new, product_id: product.id

        expect(response).to redirect_to(spree.unauthorized_path)
      end

    end

    context 'when user is a designer' do

      before(:each) do
        sign_in :spree_user, designer
      end

      it 'renders the right template' do
        get :new, product_id: product.id

        expect(response).to render_template(:new)
      end

    end

    context 'when user is admin' do

      before(:each) do
        sign_in :spree_user, admin
      end

      it 'renders the right template' do
        get :new, product_id: product.id

        expect(response).to render_template(:new)
      end

    end

  end

end
