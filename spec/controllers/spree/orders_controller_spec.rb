require 'rails_helper'

RSpec.describe Spree::OrdersController, type: :controller do
  let!(:store) { create :store }
  let(:admin) { create :admin_user }
  let(:designer) { create :designer }
  let(:customer) { create :confirmed_user }
  let(:order) { create :order_ready_to_ship }

  describe 'GET #invoice' do

    context 'when no user is logged in' do

      it 'redirects to login' do
        spree_get :invoice, format: :pdf, id: order.number

        expect(response).to redirect_to(spree.login_path)
      end

    end

    context 'when a user is logged in' do

      context 'and the order belongs to them' do

        before(:each) do
          sign_in :spree_user, order.user
        end

        it 'downloads the invoice' do
          spree_get :invoice, format: :pdf, id: order.number

          expect(response.headers['Content-Type']).to eq('application/pdf')
          expect(response.headers['Content-Disposition']).to eq("attachment; filename=#{order.number}.pdf")
        end

      end

      context 'and they are an admin' do

        before(:each) do
          sign_in :spree_user, admin
        end

        it 'downloads the invoice' do
          spree_get :invoice, format: :pdf, id: order.number

          expect(response.headers['Content-Type']).to eq('application/pdf')
          expect(response.headers['Content-Disposition']).to eq("attachment; filename=#{order.number}.pdf")
        end

      end

      context 'and the order does not belong to them' do

        before(:each) do
          sign_in :spree_user, customer
        end

        it 'downloads the invoice' do
          spree_get :invoice, format: :pdf, id: order.number

          expect(response).to redirect_to(spree.unauthorized_path)
        end

      end

    end

  end
end
