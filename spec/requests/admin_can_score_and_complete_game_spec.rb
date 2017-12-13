require 'rails_helper'

describe 'Admin can complete / score a game with finished players', type: :request do
  let(:game) { create(:game, completed: false) }
  let(:league) { game.league }
  let(:season) { game.season }
  let(:admin) { league.creator }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
  end

  context 'a game without finished players is redirected and not completed' do
    it 'redirects to the new league season game player path' do
      expect {
        patch "/leagues/#{league.slug}/seasons/#{season.id}/games/#{game.id}/completed"
      }.to_not change { game.reload.completed }.from(false)

      expect(response).to redirect_to new_league_season_game_player_path(league, season, game)
    end
  end

  context 'a game with 1 finished player is redirected and not completed' do
    it 'redirects to the new league season game player path' do
      create(:player, game: game)

      expect {
        patch "/leagues/#{league.slug}/seasons/#{season.id}/games/#{game.id}/completed"
      }.to_not change { game.reload.completed }.from(false)
    end
  end

  context 'a game with more than 1 finished players is redirected scored and completed' do
    let(:game2) { create(:game_with_first_and_second) }
    it 'redirects to the league season game path' do
      # player1, player2 = [1, 2].map { |n| create(:player, game: game, finishing_place: n, score: nil) }
      player1, player2 = game2.players

      expect {
        patch "/leagues/#{league.slug}/seasons/#{season.id}/games/#{game2.id}/completed"
      }.to change { game2.reload.completed }.from(false).to(true)

      expect(player1.reload.score).to eq(6.72)
      expect(player2.reload.score).to eq(4.48)
      expect(response).to redirect_to league_season_game_path(league, season, game2)
    end
  end
end
