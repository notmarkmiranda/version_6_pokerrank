module LeagueHelper
  include ApplicationHelper
  OPTIONS = ['league', 'season', 'game', 'player'].freeze

  OPTIONS.each_with_index do |option, index|
    define_method("load_#{option}") do
      OPTIONS[0..index].each { |opt| send(opt) }
    end
  end

  def verify_admin_for_league
    redirect_to root_path unless league.admins.include?(current_user)
  end

  private

  def league
    @league ||= League.find(league_param)
    redirect_to root_path if @league.nil?
    @league
  end

  def season
    @season ||= Season.find(season_param)
  end

  def game
    @game ||= Game.find(game_param)
  end

  def player
    @player ||= Player.find(params[:id])
  end

  def game_param
    controller_name == 'games' ? params[:id] : params[:game_id]
  end

  def league_param
    controller_name == 'leagues' ? params[:slug] : params[:league_slug]
  end

  def season_param
    controller_name == 'seasons' ? params[:id] : params[:season_id]
  end
end
