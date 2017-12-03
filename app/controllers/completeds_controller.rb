class CompletedsController < ApplicationController
  before_action :verify_admin_for_league

  def update
    if game.complete!
      redirect_to league_season_game_path(league, season, game)
    end
  end

  private

  def game
    @game ||= Game.find(params[:game_id])
  end

  def league
    @league ||= League.find(params[:league_slug])
  end

  def season
    @season ||= Season.find(params[:season_id])
  end
end
