require 'rails_helper'

RSpec.describe Nelou::Admin::DesignerLabelsController, type: :controller do
  let!(:store) { create :store }
  let(:admin) { create :admin }
  let(:designer) { create :designer }
  let(:unaccepted_designer) { create :unaccepted_designer }
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

    context 'when user is not an accepted designer' do

      before(:each) do
        sign_in :spree_user, unaccepted_designer
      end

      it 'redirects to root' do
        get :index

        expect(response).to redirect_to(spree.root_path)
      end

    end

    context 'when user is an accepted designer' do

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

  describe 'GET #edit' do

    context 'when user has no role' do

      before(:each) do
        sign_in :spree_user, customer
      end

      it 'redirects to unauthorized' do
        get :edit, id: designer.designer_label

        expect(response).to redirect_to(spree.admin_unauthorized_path)
      end

    end

    context 'when user is a designer' do

      before(:each) do
        sign_in :spree_user, designer
      end

      context 'when editing own designer label' do

        it 'renders the right template' do
          get :edit, id: designer.designer_label.slug

          expect(response).to render_template(:edit)
        end

      end

      context 'when editing others designer label' do

        it 'redirects to unauthorized' do
          other_designer = FactoryGirl.create(:designer)

          put :edit, id: other_designer.designer_label.slug
          expect(response).to redirect_to(spree.admin_unauthorized_path)
        end

      end

    end

    context 'when user is admin' do

      before(:each) do
        sign_in :spree_user, admin
      end

      it 'renders the right template' do
        get :edit, id: designer.designer_label

        expect(response).to render_template(:edit)
      end

    end

  end

  describe 'PUT #update/:id' do
    let(:attr) do
      {
        name: Faker::Name.name,
        profile: Faker::Lorem.paragraphs.join("\n"),
        short_description: Faker::Lorem.paragraph,
        logo: fixture_file_upload('files/designer_labels/test-logo.png', 'image/png'),
        profile_image: fixture_file_upload('files/designer_labels/test-profile.png', 'image/png')
      }
    end

    context 'when user has no role' do
      let(:designer_label) { designer.designer_label }

      before(:each) do
        sign_in :spree_user, customer
      end

      it 'redirects to unauthorized' do
        put :update, id: designer_label.slug, nelou_designer_label: attr

        expect(response).to redirect_to(spree.admin_unauthorized_path)
      end

    end

    context 'when user is a designer' do

      context 'when updating own designer label' do

        let(:designer_label) { designer.designer_label }

        before(:each) do
          sign_in :spree_user, designer
        end

        it 'redirects to edit view' do
          put :update, id: designer_label.slug, nelou_designer_label: attr

          expect(response).to redirect_to(action: :edit)
        end

        it 'updates the designer label successfully' do
          put :update, id: designer_label.slug, nelou_designer_label: attr

          designer_label.reload

          expect(designer_label.name).to be == attr[:name]
          expect(designer_label.profile).to be == attr[:profile]
          expect(designer_label.short_description).to be == attr[:short_description]
        end

      end

      context "when updating other's designer label" do

        let(:other_designer) { FactoryGirl.create(:designer) }

        before(:each) do
          sign_in :spree_user, designer
        end

        it 'redirects to unauthorized' do
          put :update, id: other_designer.designer_label.slug, nelou_designer_label: attr

          expect(response).to redirect_to(spree.admin_unauthorized_path)
        end

      end

    end

    context 'when user is admin' do

      let(:designer_label) { designer.designer_label }

      before(:each) do
        sign_in :spree_user, admin
      end

      it 'redirects to index view' do
        put :update, id: designer_label.slug, nelou_designer_label: attr

        expect(response).to redirect_to(action: :edit)
      end

      it 'updates the designer label successfully' do
        put :update, id: designer_label.slug, nelou_designer_label: attr

        designer_label.reload

        expect(designer_label.name).to be == attr[:name]
        expect(designer_label.profile).to be == attr[:profile]
        expect(designer_label.short_description).to be == attr[:short_description]
      end

    end

  end
end
