class GamesController < ApplicationController
  before_action :load_league_and_season, only: [:show, :new, :edit, :update]
  before_action :load_game, only: [:show, :edit, :update]
  before_action :verify_admin_for_league, only: [:new, :create, :edit, :update]

  def show
  end

  def new
    @game = season.games.new
  end

  def create
    @game = season.games.new(game_params)
    if @game.save
      redirect_to league_season_game_path(league, season, @game)
    else
      redirect_to new_league_season_game_path(league, season)
    end
  end

  def edit
  end

  def update
    if @game.update(game_params)
      redirect_to league_season_game_path(league, season, @game)
    else
      redirect_to edit_league_season_game_path(league, season, @game)
    end
  end

  private

  def verify_admin_for_league
    redirect_to root_path unless league.admins.include?(current_user)
  end

  def game
    @game = Game.find(params[:id])
  end

  def game_params
    params.require(:game).permit(:date, :buy_in, :attendees)
  end

  def league
    @league ||= League.find(params[:league_slug])
  end

  def load_game
    game
  end

  def load_league_and_season
    league && season
  end

  def season
    @season ||= Season.find(params[:season_id])
  end
end
