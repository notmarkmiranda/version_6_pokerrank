class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user
  helper_method :redirect_logged_in_user_to_dashboard
  helper_method :require_user

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def redirect_logged_in_user_to_dashboard
    redirect_to dashboard_path if current_user
  end

  def require_user
    redirect_to root_path if !current_user
  end
end
