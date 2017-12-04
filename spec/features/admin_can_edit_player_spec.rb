require 'rails_helper'

describe 'Admin can edit a player', type: :feature do
  let(:player) { create(:player) }
  let(:game) { player.game }
  let(:season) { game.season }
  let(:league) { season.league }
  let(:admin) { league.creator }
  let(:member) do
    user = create(:user)
    league.grant_membership(user)
    user
  end

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)
  end

  scenario 'it redirects on successful edit' do
    visit new_league_season_game_player_path(league, season, game)

    click_link "Edit #{player.full_name}"
    fill_in "Finishing Place", with: 10
    click_button "Update Player!"

    expect(current_path).to eq(new_league_season_game_player_path(league, season, game))
    expect(page).to have_content(player.full_name)
    expect(page).to have_content('Place: 10')
  end
end
