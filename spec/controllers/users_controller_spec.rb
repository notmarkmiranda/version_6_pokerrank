require 'rails_helper'

describe UsersController, type: :controller do
  context 'GET#show' do
    it 'renders the show template' do
      user = create(:user)
      get :show, session: { user_id: user.id }
      expect(response).to render_template(:show)
    end
  end

  context 'GET#new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end

    it 'redirects to dashboard_path if user is logged in' do
      user = create(:user)
      get :new, session: { user_id: user.id }
      expect(response).to redirect_to(dashboard_path)
    end
  end

  context 'POST#create' do
    it 'redirects to dashboard path on successful creation' do
      attrs = attributes_for(:user)
      post :create, params: { user: attrs }
      expect(response).to redirect_to dashboard_path
    end

    it 'renders the new template when something goes wrong' do
      attrs = attributes_for(:user)
      post :create, params: { user: attrs.except(:first_name) }
      expect(response).to render_template(:new)
    end
  end

  context 'GET#edit' do
    it 'renders the edit template' do
      user = create(:user)
      get :edit, session: { user_id: user.id }
      expect(response).to render_template(:edit)
    end

    it 'redirects to root_path if there is no user logged in' do
      get :edit
      expect(response).to redirect_to(root_path)
    end
  end

  context 'PATCH#update' do
    before do
      @user = create(:user)
    end

    it 'redirect to dashboard path on succesful update' do
      patch :update, params: { id: @user.id, user: { first_name: 'Mark' } }, session: { user_id: @user.id }
      expect(response).to redirect_to dashboard_path
    end

    it 'renders edit when something goes wrong' do
      patch :update, params: { id: @user.id, user: { first_name: '' } }, session: { user_id: @user.id }
      expect(response).to render_template :edit
    end

    it 'redirects to root path if mismatched users' do
      user2 = create(:user)
      patch :update, params: { id: user2.id, user: { first_name: 'Mark' } }, session: { user_id: @user.id }
      expect(response).to redirect_to root_path
    end
  end
end

