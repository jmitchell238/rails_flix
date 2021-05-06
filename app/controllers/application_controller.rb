class ApplicationController < ActionController::Base

  private

  def current_user
    # Store user object in local variable. Prevents multiple database request.
    # without @current_user ||= you get 3 db request. With it, you get only 1
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  helper_method :current_user

  def current_user?(user)
    current_user == user
  end

  helper_method :current_user?

  def current_user_admin?
    current_user&.admin?
  end

  helper_method :current_user_admin?

  def require_signin
    session[:intended_url] = request.url
    redirect_to new_session_url, alert: 'Please sign in first!' unless current_user
  end

  def require_admin
    redirect_to movies_url, alert: 'Unauthorized access!' unless current_user_admin?
  end

end
