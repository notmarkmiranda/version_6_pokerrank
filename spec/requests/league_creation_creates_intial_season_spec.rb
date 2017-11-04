require 'rails_helper'

describe 'League creation also creates a season' do
  it 'creates a season' do
    user = create(:user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    attrs = attributes_for(:league)
    expect {
      post '/leagues', params: { league: attrs }
    }.to change(League, :count).by(1)
    .and change(Season, :count).by(1)
  end
end
