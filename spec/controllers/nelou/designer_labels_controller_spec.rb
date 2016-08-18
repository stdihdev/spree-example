require 'rails_helper'

RSpec.describe Nelou::DesignerLabelsController, type: :controller do
  let!(:store) { create :store }
  let(:customer) { create :confirmed_user }
  let(:designer_label) { create :designer_label }
  let(:disabled_designer_label) { create :disabled_designer_label }

  # The Spree Controller Helper overrides the default router, we have to set it to the main-app router again
  # TODO: Find more elegant solution
  routes { Rails.application.routes }

  describe 'GET #show' do
    it 'renders the right template' do
      get :show, id: designer_label.slug
      expect(response).to render_template(:show)
    end

    it 'does not show a disabled label' do
      expect {
        get :show, id: disabled_designer_label.slug
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
