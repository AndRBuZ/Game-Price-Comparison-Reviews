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
    unless logged_in?
      respond_to do |format|
        format.html { redirect_to login_path, alert: "You must be logged in" }
        format.turbo_stream do
          flash[:alert] = "You must be logged in"
          render turbo_stream: turbo_stream.action(:redirect, login_path)
        end
      end
    end
  end
end
