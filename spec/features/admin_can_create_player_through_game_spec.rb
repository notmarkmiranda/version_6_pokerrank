require 'rails_helper'

describe 'Admin can create a player from within a game', type: :feature do
  let(:game) { create(:game) }
  let(:league) { game.league }
  let(:season) { game.season }
  let(:admin) { league.creator }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
  end

  scenario 'it creates a player and redirects them back to the new league season game player path' do
    visit league_season_game_path(league, season, game)

    click_link 'Score Game'

    expect(current_path).to eq(new_league_season_game_player_path(league, season, game))

    select admin.full_name, from: 'Player Name'
    fill_in 'Additional Expense', with: '15'
    fill_in 'Finishing Place', with: '10'
    click_button 'Score!'

    expect(current_path).to eq(new_league_season_game_player_path(league, season, game))
  end
end
