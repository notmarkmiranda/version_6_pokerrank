class CompletedsController < ApplicationController
  include LeagueHelper

  before_action :verify_admin_for_league

  def update
    return check_for_players if game.players_count < 2
    game.complete!
    redirect_to league_season_game_path(league, season, game)
  end

  private

  def check_for_players
    flash[:danger] = 'You cannot complete a game that does not have any players in it'
    redirect_to new_league_season_game_player_path(league, season, game)
  end
end
