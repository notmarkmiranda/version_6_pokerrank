require 'rails_helper'

describe CompletedsController, type: :controller do
  context 'PATCH#update' do
    let(:game) { create(:game_with_first_and_second) }
    let(:league) { game.league }
    let(:admin) { league.creator }
    let(:season) { game.season }
    let(:member) do
      user = create(:user)
      league.grant_membership(user)
      user
    end

    it 'redirects to league_season_game_path for an already completed game' do
      game.complete!
      patch :update, session: { user_id: admin.id }, params: { league_slug: league.slug, season_id: season.id, game_id: game.id }

      expect(response).to redirect_to league_season_game_path(league, season, game)
    end

    it 'redirects to league_season_game_path for an incomplete game' do
      game.uncomplete!
      patch :update, session: { user_id: admin.id }, params: { league_slug: league.slug, season_id: season.id, game_id: game.id }

      expect(response).to redirect_to league_season_game_path(league, season, game)
    end

    it 'redirects to root path for a non-admin' do
      patch :update, session: { user_id: member.id }, params: { league_slug: league.slug, season_id: season.id, game_id: game.id }

      expect(response).to redirect_to root_path
    end

    it 'redirects to root path for a visitor' do
      patch :update, params: { league_slug: league.slug, season_id: season.id, game_id: game.id }

      expect(response).to redirect_to root_path
    end
  end
end
