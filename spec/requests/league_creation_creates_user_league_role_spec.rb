require 'rails_helper'

describe 'league creation triggers user_league_role creation' do
  before do
    @user = create(:user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end

  it 'creates a user_league_role as an admin & invited true' do
    attrs = attributes_for(:league)
    expect {
      post '/leagues', params: { league: attrs }
    }.to change(League, :count).by(1)
     .and change(UserLeagueRole, :count).by(1)
  end
end
