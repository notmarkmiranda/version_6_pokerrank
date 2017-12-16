module LeagueHelper
  include ApplicationHelper

  def load_league
    league
  end

  def load_season
    load_league
    season
  end

  def load_user
    load_league
    user
  end

  def load_game
    load_season
    game
  end

  def load_player
    load_game
    player
  end

  def verify_admin_for_league
    redirect_to root_path unless league.admins.include?(current_user)
  end

  private

  def game
    @game ||= Game.find(game_param)
  end

  def game_param
    controller_name == 'games' ? params[:id] : params[:game_id]
  end

  def league
    @league ||= League.find(league_param)
    redirect_to root_path if @league.nil?
    @league
  end

  def league_param
    controller_name == 'leagues' ? params[:slug] : params[:league_slug]
  end

  def season
    @season ||= Season.find(season_param)
  end

  def season_param
    controller_name == 'seasons' ? params[:id] : params[:season_id]
  end

  def player
    @player ||= Player.find(params[:id])
  end

  def user
    @user ||= User.find(params[:id])
  end
end
