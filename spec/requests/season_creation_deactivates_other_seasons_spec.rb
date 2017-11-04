require 'rails_helper'

describe 'Season creation deactives other seasons' do
  let(:league) { create(:league) }
  it 'deactivates the initial season' do
    first_season = league.seasons.first
    attrs = attributes_for(:season, league: league)

    expect {
      post "/leagues/#{league.slug}/seasons", params: { slug: league.slug, season: attrs }
    }.to change{ first_season.reload.active }.from(true).to(false)
  end
end
