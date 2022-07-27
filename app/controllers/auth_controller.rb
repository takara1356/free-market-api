class AuthController < ApplicationController

  def login
    user = User.find_by(email: login_params[:email])
    raise AuthenticationError.new('パスワードが一致していない、もしくはユーザーが存在しません') if user.blank?
    token = SecureRandom.urlsafe_base64

    valid = User.account_authenticate(user, login_params)

    ActiveRecord::Base.transaction do
      user.save_new_token!(token)
    end
  end

  private

  def login_params
    params.require(:login_info).permit(:email, :password)
  end
end
