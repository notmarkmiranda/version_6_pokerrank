class SeasonsController < ApplicationController
  include LeagueHelper

  before_action :load_season, only: [:show]
  before_action :verify_admin_for_league, only: [:create]

  def show
  end

  def create
    @season = league.seasons.create!(season_params)
    redirect_to league_season_path(@league, @season)
  end

  private

  def season_params
    params.require(:season).permit(:league_id, :active)
  end
end
