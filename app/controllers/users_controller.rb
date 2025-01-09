class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path, notice: "User created successfully"
    else
      render turbo_stream: [
      turbo_stream.replace("signup_errors", partial: "shared/errors", locals: { resource: @user }),
      turbo_stream.replace("signup_form", partial: "users/form", locals: { user: @user, form_url: users_path, form_method: :post, button_text: "Sign Up" })
    ]
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :nickname, :password, :password_confirmation)
  end
end
