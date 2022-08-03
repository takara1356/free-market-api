class UsersController < ApplicationController
  skip_before_action :authenticate_token, only: [:create]

  # ユーザー新規登録
  def create
    user = User.create(user_params)
    render json: user
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
