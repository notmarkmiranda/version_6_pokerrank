class CompletedsController < ApplicationController
  include LeagueHelper

  before_action :verify_admin_for_league

  def update
    game.complete!
    redirect_to league_season_game_path(league, season, game)
  end
end
