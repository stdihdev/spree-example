require 'rails_helper'

RSpec.describe Nelou::ErrorsController, type: :controller do

  # The Spree Controller Helper overrides the default router, we have to set it to the main-app router again
  # TODO: Find more elegant solution
  routes { Rails.application.routes }

  describe 'GET #not_found' do
    it 'returns http not found' do
      get :not_found
      expect(response).to have_http_status(:not_found)
    end
  end

end
