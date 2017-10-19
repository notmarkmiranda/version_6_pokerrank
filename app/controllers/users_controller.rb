class UsersController < ApplicationController
  before_action :redirect_logged_in_user_to_dashboard, only: [:new]
  before_action :require_user, only: [:edit]
  before_action :verify_user, only: [:update]

  def show
    @user = current_user
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to dashboard_path
    else
      render :new
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to dashboard_path
    else
      render :edit
    end
  end

  private

  def verify_user
    redirect_to root_path unless current_user && params[:id].to_i == current_user.id
  end

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :password)
  end
end
