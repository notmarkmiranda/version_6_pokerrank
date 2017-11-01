require 'rails_helper'

describe SessionsController, type: :controller do
  let(:user) { create(:user) }

  context 'GET#new' do
    it 'renders the new template for a visitor' do
      get :new
      expect(response).to render_template(:new)
    end

    it 'redirects to root path for a logged in user' do
      get :new, session: { user_id: user.id }
      expect(response).to redirect_to root_path
    end
  end

  context 'POST#create' do
    it 'redirects to the dashboard_path on successful log in' do
      post :create, params: { session: { email: user.email, password: 'password' } }
      expect(response).to redirect_to dashboard_path
    end

    it 'renders the new template when unsuccessful' do
      post :create, params: { session: { email: user.email, password: 'passwordz' } }
      expect(response).to render_template :new
    end
  end

  context 'GET#destroy' do
    it 'redirects to root path' do
      get :destroy, session: { user_id: user.id }
      expect(response).to redirect_to root_path
    end
  end
end
