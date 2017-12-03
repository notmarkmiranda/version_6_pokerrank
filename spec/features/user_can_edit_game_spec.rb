require 'rails_helper'

describe 'User can edit a game', type: :feature do
  let(:league) { create(:league) }
  let(:season) { league.active_season }
  let(:game) { create(:game, season: season) }
  let(:user) { league.creator }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  end

  it 'allows the user to edit an incomplete game' do
    visit league_season_game_path(league, season, game)
    click_link 'Edit Game'
    fill_in 'Date', with: '12/06/2017'
    click_button 'Update Game!'

    expect(current_path).to eq(league_season_game_path(league, season, game))
  end

  it 'does not allow a user to edit a complete game' do
    game.update(completed: true)
    visit league_season_game_path(league, season, game)
    expect(page).to have_content(game.full_date)
    expect(page).to_not have_link('Edit Game')
  end

  it 'redirects without the proper attributes' do
    visit league_season_game_path(league, season, game)
    click_link 'Edit Game'
    fill_in 'Date', with: ''
    click_button 'Update Game!'

    expect(current_path).to eq(edit_league_season_game_path(league, season, game))
  end
end
