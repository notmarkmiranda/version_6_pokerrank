require 'rails_helper'

describe 'Admin can create a new user from a game', type: :feature do
  let(:game) { create(:game) }
  let(:season) { game.season }
  let(:league) { game.league }
  let(:admin) { league.creator }

  context 'as an admin' do
    before do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
    end

    it 'creates a new user and redirects to game path' do
      visit new_league_season_game_player_path(league, season, game)

      within('.new-player-form') do
        click_link 'New Player'
      end

      fill_in 'E-Mail Address', with: 'a@b.com'
      fill_in 'First Name', with: 'Mark'
      fill_in 'Last Name', with: 'Miranda'
      click_button 'Create Player!'

      expect(current_path).to eq(new_league_season_game_player_path(league, season, game))
    end
  end
end
