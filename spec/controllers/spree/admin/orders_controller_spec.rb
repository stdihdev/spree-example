require 'rails_helper'

RSpec.describe Spree::Admin::OrdersController, type: :controller do
  let!(:store) { create :store }
  let(:designer) { create :designer }

  describe 'GET #index' do

    context 'when user is a designer' do

      before(:each) do
        sign_in :spree_user, designer
      end

      it 'renders the right template' do
        spree_get :index

        expect(response).to render_template(:index)
      end

    end

  end

  # TODO: Figure out how to make a test for the edit route (viewing)
end
