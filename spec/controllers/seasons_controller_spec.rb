require 'rails_helper'

describe SeasonsController, type: :controller do
  context 'POST#create' do
    let(:league) { create(:league) }
    it 'redirects to the league season path on successful creation' do
      attrs = attributes_for(:season, league: league)
      post :create, params: { league_slug: league.slug, season: attrs }
      expect(response).to redirect_to league_season_path(league, league.seasons.last)
    end
  end
end
