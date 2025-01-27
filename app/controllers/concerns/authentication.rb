module Authentication
  extend ActiveSupport::Concern

  included do
    helper_method :current_user, :logged_in?, :authenticate_user!
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user.present?
  end

  def authenticate_user!
    redirect_to login_path, alert: "You must be logged in to perform that action" unless logged_in?
  end
end
