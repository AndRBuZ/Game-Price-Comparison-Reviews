class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :steam

  def new; end

  def create
    if request.env["omniauth.auth"]
      omniauth_user
    else
      local_user
    end
  end

  def steam
    omniauth_user
  end

  def destroy
    session.delete(:user_id)
    redirect_to root_path, notice: "Logged out successfully"
  end

  private

  def local_user
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: "Logged in successfully"
    else
      redirect_to login_path, alert: "Invalid email or password"
    end
  end

  def omniauth_user
    user = User.from_omniauth(request.env["omniauth.auth"])
    session[:user_id] = user.id
    redirect_to root_path, notice: "Logged in successfully"
  end
end
