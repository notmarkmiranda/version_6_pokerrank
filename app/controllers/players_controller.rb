class PlayersController < ApplicationController
  include LeagueHelper

  before_action :load_game, only: [:new]
  before_action :load_player, only: [:edit, :update]
  before_action :verify_admin_for_league, except: [:show]

  def new
    @player = Player.new
  end

  def create
    @player = game.players.new(player_params)
    @player.save
    flash[:alert] = @player.errors.full_messages if @player.errors
    redirect_to new_league_season_game_player_path(league, season, game)
  end

  def edit
  end

  def update
    @player.update(player_params)
    flash[:alert] =  @player.errors.full_messages if @player.errors
    redirect_to new_league_season_game_player_path(league, season, game)
  end

  private

  def player_params
    params.require(:player).permit(:user_id, :additional_expense, :finishing_place)
  end
end
