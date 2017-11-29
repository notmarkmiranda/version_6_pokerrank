require 'rails_helper'

describe GamesController, type: :controller do
  let(:game) { create(:game) }
  let(:league) { game.league }
  let(:season) { game.season }
  let(:admin) { league.admins.first }
  let(:attrs) { attributes_for(:game) }
  let(:member) do
    user = create(:user)
    league.grant_membership(user)
    user
  end

  context 'GET#show' do
    it 'renders the show template' do
      get :show, params: { league_slug: league.slug, season_id: season.id, id: game.id }

      expect(response).to render_template :show
    end
  end

  context 'GET#new' do
    it 'renders the new template' do
      get :new, session: { user_id: admin.id }, params: { league_slug: league.slug, season_id: season.id }

      expect(response).to render_template :new
    end

    it 'redirects if the user is not an admin' do
      get :new, session: { user_id: member.id }, params: { league_slug: league.slug, season_id: season.id }

      expect(response).to redirect_to root_path
    end
  end

  context 'POST#create' do
    it 'redirects to league_season_game_path on successful creation' do
      post :create, session: { user_id: admin.id }, params: { league_slug: league.slug, season_id: season.id, game: attrs }

      expect(response).to redirect_to league_season_game_path(league, season, Game.last)
    end

    it 'redirects to the new_league_season_game_path on unsuccessful creation' do
      post :create, session: { user_id: admin.id }, params: { league_slug: league.slug, season_id: season.id, game: attrs.except(:attendees) }

      expect(response).to redirect_to new_league_season_game_path(league, season)
    end

    it 'redirects to the root_path if user is not an admin' do
      post :create, session: { user_id: member.id }, params: { league_slug: league.slug, season_id: season.id, game: attrs.except(:attendees) }

      expect(response).to redirect_to root_path
    end
  end

  context 'GET#edit' do
    it 'renders the edit template' do
      get :edit, session: { user_id: admin.id }, params: { league_slug: league.slug, season_id: season.id, id: game.id }

      expect(response).to render_template :edit
    end

    it 'redirects to root path if not an admin' do
      get :edit, session: { user_id: member.id }, params: { league_slug: league.slug, season_id: season.id, id: game.id }

      expect(response).to redirect_to root_path
    end
  end

  context 'PATCH#update' do
    it 'redirects to the game page on successful update' do
      patch :update, session: { user_id: admin.id }, params: { league_slug: league.slug, season_id: season.id, id: game.id, game: { date: '12/06/2017' } }

      expect(response).to redirect_to league_season_game_path(league, season, game)
    end

    it 'redirects to the edit page on unsuccessful update' do
      patch :update, session: { user_id: admin.id }, params: { league_slug: league.slug, season_id: season.id, id: game.id, game: { date: '' } }

      expect(response).to redirect_to edit_league_season_game_path(league, season, game)
    end

    it 'redirects to root path for a non-admin' do
      patch :update, session: { user_id: member.id }, params: { league_slug: league.slug, season_id: season.id, id: game.id, game: { date: '' } }

      expect(response).to redirect_to root_path
    end
  end
end
