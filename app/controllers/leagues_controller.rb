class LeaguesController < ApplicationController
  include LeagueHelper

  before_action :load_league, only: [:show, :edit, :update]
  before_action :require_user, except: [:show]

  def show
    @active_season = @league.active_season
  end

  def new
    @league = current_user.created_leagues.new
  end

  def create
    @league = current_user.created_leagues.new(league_params)
    if @league.save
      redirect_to league_path(@league)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @league.update(league_params)
      redirect_to league_path(@league)
    else
      render :edit
    end
  end

  private

  def league_params
    params.require(:league).permit(:name)
  end
end
