class AuthController < ApplicationController
  skip_before_action :authenticate_token, only: [:login]

  def login
    user = User.find_by(email: login_params[:email])
    raise AuthenticationError.new(AuthenticationError::DEFAULT_MESSAGE) if user.blank?
    # token = SecureRandom.urlsafe_base64
    token = 'sample_token'

    valid = User.account_authenticate(user, login_params)

    ActiveRecord::Base.transaction do
      user.save_new_token!(token)
    end

    render json: { token: token }
  end

  def logout
    ActiveRecord::Base.transaction do
      @current_user.update!(token: nil)
    end

    render json: { message: 'ログアウトしました' }
  end

  private

  def login_params
    params.require(:login_info).permit(:email, :password)
  end
end
