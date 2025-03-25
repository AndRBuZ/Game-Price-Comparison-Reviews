class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :omniauth_callback

  def new; end

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: "Logged in successfully"
    else
      redirect_to login_path, alert: "Invalid email or password"
    end
  end

  def omniauth_callback
    auth_data = request.env["omniauth.auth"]
    user = User.from_omniauth(auth_data)
    session[:user_id] = user.id
    redirect_to root_path, notice: "Logged in successfully"
  end

  def destroy
    session.delete(:user_id)
    redirect_to root_path, notice: "Logged out successfully"
  end
end
