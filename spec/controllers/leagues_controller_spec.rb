require 'rails_helper'

describe LeaguesController, type: :controller do

  context 'non-existing leagues' do
    let(:user) { create(:user) }

    context 'GET#new' do
      it 'render the new template' do
        get :new, session: { user_id: user.id }
        expect(response).to render_template(:new)
      end

      it 'redirects to root path without a user' do
        get :new
        expect(response).to redirect_to(root_path)
      end
    end

    context 'POST#create' do
      it 'redirects to league_path on successful creation' do
        attrs = attributes_for(:league, name: 'marks league')
        post :create, session: { user_id: user.id }, params: { league: attrs }

        expect(response).to redirect_to(league_path(slug: 'marks-league'))
      end

      it 'renders the new template on unsuccesful creation' do
        attrs = attributes_for(:league, name: 'marks league')
        post :create, session: { user_id: user.id }, params: { league: attrs.except(:name) }

        expect(response).to render_template(:new)
      end

      it 'redirects to root path without a user' do
        attrs = attributes_for(:league, name: 'marks league')
        post :create, params: { league: attrs }

        expect(response).to redirect_to(root_path)
      end

      it 'redirects to root path without a user or a league name' do
        attrs = attributes_for(:league, name: 'marks league')
        post :create, params: { league: attrs.except(:name) }

        expect(response).to redirect_to(root_path)
      end
    end
  end

  context 'existing leagues' do
    let(:league) { create(:league) }
    let(:user) { league.creator }

    context 'GET#show' do
      it 'renders the show template' do
        get :show, params: { slug: league.slug }
        expect(response).to render_template :show
      end

      it 'redirects if the league does not exist' do
        get :show, params: { slug: 'something-else' }
        expect(response).to redirect_to root_path
      end
    end

    context 'GET#edit' do
      it 'renders the edit template' do
        get :edit, session: { user_id: user.id }, params: { slug: league.slug }
        expect(response).to render_template(:edit)
      end

      it 'redirects to root path without a user' do
        get :edit, params: { slug: league.slug }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'PATCH#update' do
      it 'redirects to league_path on successful update' do
        patch :update, params: { slug: league.slug, league: { name: 'yup' } }, session: { user_id: user.id }
        expect(response).to redirect_to(league_path(slug: 'yup'))
      end

      it 'renders the edit template on an unsuccessful update' do
        patch :update, params: { slug: league.slug, league: { name: '' } }, session: { user_id: user.id }
        expect(response).to render_template :edit
      end
    end
  end
end
