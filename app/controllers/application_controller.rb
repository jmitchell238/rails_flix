class ApplicationController < ActionController::Base

  private

  def current_user
    # Store user object in local variable. Prevents multiple database request.
    # without @current_user ||= you get 3 db request. With it, you get only 1
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  helper_method :current_user

  def require_signin
    redirect_to new_session_url, alert: 'Please sign in first!' unless current_user
  end

end
