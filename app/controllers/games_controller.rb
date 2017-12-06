class GamesController < ApplicationController
  include LeagueHelper
  before_action :load_season, only: [:new]
  before_action :load_game, only: [:show, :edit, :update]
  before_action :verify_admin_for_league, only: [:new, :create, :edit, :update]
  before_action :redirect_if_game_completed, only: [:edit, :update]

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

  def redirect_if_game_completed
    redirect_to league_season_game_path(league, season, game) if game.completed?
  end

  def game_params
    params.require(:game).permit(:date, :buy_in, :attendees)
  end
end
