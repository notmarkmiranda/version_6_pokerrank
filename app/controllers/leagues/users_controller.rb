class Leagues::UsersController < ApplicationController
  include LeagueHelper

  before_action :load_user, only: [:show]
  before_action :load_league, only: [:index, :new, :create]

  def index
    @users = @league.users
  end

  def show
  end

  def new
    session[:redirect] = redirect
    @user = User.new
  end

  def create
    @user = User.new(filtered_user_params)
    league_user = LeagueUserCreator.new(user: @user, league: @league, user_league_role: user_league_role_params)
    if league_user.save
      redirect_to session[:redirect]
    else
      render :new
    end
  end

  private

  def filtered_user_params
    user_params.except(:user_league_role)
  end

  def redirect
    if request.referrer && request.referer.ends_with?('/players/new')
      request.referrer
    else
      league_users_path(@league)
    end
  end

  def user_league_role_params
    user_params[:user_league_role]
  end

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, user_league_role: [:invited, :admin])
  end
end

