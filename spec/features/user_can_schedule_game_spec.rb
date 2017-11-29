require 'rails_helper'

describe 'User can schedule a game' do
  let(:league) { create(:league) }
  let(:season) { league.active_season }
  let(:user) { league.creator }

  before do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    visit league_season_path(league, season)
    click_link "Schedule Game"
    fill_in "Buy In", with: "100"
    fill_in "Attendees", with: "25"
  end

  it 'happiest of paths' do
    fill_in "Date", with: "01/01/2012"
    click_button "Schedule!"

    expect(current_path).to eq(league_season_game_path(league, season, Game.last))
  end

  it 'sad path, with no date' do
    click_button "Schedule!"
    expect(current_path).to eq(new_league_season_game_path(league, season))
  end
end
