require 'rails_helper'

describe SeasonsController, type: :controller do
  context 'GET#show' do
    let(:season) { create(:season) }
    let(:league) { season.league }

    it 'renders the show template' do
      get :show, params: { league_slug: league.slug, id: season.id }

      expect(response).to render_template :show
    end
  end

  context 'POST#create' do
    let(:league) { create(:league) }
    let(:admin) { league.creator }
    let(:attrs) { attributes_for(:season, league: league) }
    let(:member) do
      user = create(:user)
      league.grant_membership(user)
      user
    end

    it 'redirects to the league season path on successful creation' do
      post :create, session: { user_id: admin.id }, params: { league_slug: league.slug, season: attrs }

      expect(response).to redirect_to league_season_path(league, league.seasons.last)
    end

    it 'redirects a user that is not an admin' do
      post :create, session: { user_id: member.id }, params: { league_slug: league.slug, season: attrs }

      expect(response).to redirect_to root_path
    end
  end
end
