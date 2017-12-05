require 'rails_helper'

describe PlayersController, type: :controller do
  let(:player) { create(:player) }
  let(:game) { player.game }
  let(:league) { game.league }
  let(:season) { game.season }
  let(:admin) { league.creator }
  let(:attrs) { attributes_for :player }
  let(:member) do
    user = create(:user)
    league.grant_membership(user)
    user
  end

  context 'GET#new' do
    it 'allows an admin to place a player' do
      get :new, session: { user_id: admin.id }, params: { league_slug: league.slug, season_id: season.id, game_id: game.id }

      expect(response).to render_template :new
    end

    it 'redirects a non-admin to the root path' do
      get :new, session: { user_id: member.id }, params: { league_slug: league.slug, season_id: season.id, game_id: game.id }

      expect(response).to redirect_to root_path
    end

    it 'redirects visitor to the root path' do
      get :new, params: { league_slug: league.slug, season_id: season.id, game_id: game.id }

      expect(response).to redirect_to root_path
    end
  end

  context 'POST#create' do
    it 'redirects admin to new_league_season_game_player_path on successful player creation' do
      post :create, session: { user_id: admin.id }, params: { league_slug: league.slug, season_id: season.id, game_id: game.id, player: attrs.merge(user_id: member.id) }

      expect(response).to redirect_to new_league_season_game_player_path(league, season, game)
    end

    it 'redirects admin to new_league_season_game_player_path on unsuccessful player creation' do
      post :create, session: { user_id: admin.id }, params: { league_slug: league.slug, season_id: season.id, game_id: game.id, player: attrs }

      expect(response).to redirect_to new_league_season_game_player_path(league, season, game)
    end

    it 'redirects member to root_path' do
      post :create, session: { user_id: member.id }, params: { league_slug: league.slug, season_id: season.id, game_id: game.id, player: attrs.merge(user_id: member.id) }

      expect(response).to redirect_to root_path
    end

    it 'redirects visitor to root_path' do
      post :create, params: { league_slug: league.slug, season_id: season.id, game_id: game.id, player: attrs.merge(user_id: member.id) }

      expect(response).to redirect_to root_path
    end
  end

  context 'GET#edit' do
    it 'renders the new tempalte for an admin' do
      get :edit, session: { user_id: admin.id }, params: { league_slug: league.slug, season_id: season.id, game_id: game.id, id: player.id }

      expect(response).to render_template(:edit)
    end

    it 'redirects member to root path' do
      get :edit, session: { user_id: member.id }, params: { league_slug: league.slug, season_id: season.id, game_id: game.id, id: player.id }

      expect(response).to redirect_to root_path
    end

    it 'redirects visitor to root_path' do
      get :edit, params: { league_slug: league.slug, season_id: season.id, game_id: game.id, id: player.id }

      expect(response).to redirect_to root_path
    end
  end

  context 'PATCH#update' do
    it 'redirects to new_league_season_game_player_path on successful update' do
      patch :update, session: { user_id: admin.id }, params: { league_slug: league.slug, season_id: season.id, game_id: game.id, id: player.id, player: { finishing_place: 2 } }

      expect(response).to redirect_to new_league_season_game_player_path(league, season, game)
    end

    it 'redirects non-admin to root_path' do
      patch :update, session: { user_id: member.id }, params: { league_slug: league.slug, season_id: season.id, game_id: game.id, id: player.id, player: { finishing_place: 2 } }

      expect(response).to redirect_to root_path
    end

    it 'redirects visitor to root_path' do
      patch :update, params: { league_slug: league.slug, season_id: season.id, game_id: game.id, id: player.id, player: { finishing_place: 2 } }

      expect(response).to redirect_to root_path
    end
  end
end
