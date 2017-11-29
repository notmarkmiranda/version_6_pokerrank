class SeasonsController < ApplicationController
  def show
    @league = league
    @season = Season.find(params[:id])
  end

  def create
    @season = league.seasons.create!(season_params)
    redirect_to league_season_path(@league, @season)
  end

  private

  def season_params
    params.require(:season).permit(:league_id, :active)
  end

  def league
    @league ||= League.find(params[:league_slug])
  end
end
