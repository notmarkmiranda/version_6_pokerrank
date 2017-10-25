class SessionsController < ApplicationController
  before_action :redirect_user, only: [:new]

  def new
  end

  def create
    @user = User.find_by email: params[:session][:email]
    if @user && @user.authenticate(params[:session][:password])
      session[:user_id] = @user.id
      redirect_to dashboard_path
    else
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  private

  def redirect_user
    redirect_to root_path if current_user
  end
end
