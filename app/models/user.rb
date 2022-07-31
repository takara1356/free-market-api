class User < ApplicationRecord
  # TODO: パラメータのバリデーション
  has_secure_password

  has_many :user_items
  has_many :items, dependent: :destroy, through: :user_items

  REGISTRATION_REWARD_POINT = 10000

  def self.create(params)
    valid_password(params[:password], params[:password_confirmation])
    # TODO: 例外処理の追加
    ApplicationRecord.transaction do
      user = create!(name: params[:name],
              email: params[:email],
              password: params[:password],
              password_confirmation: params[:password_confirmation],
              point: REGISTRATION_REWARD_POINT)
      user
    end
  end

  def save_new_token!(token)
    token_digest = Digest::SHA256.digest(token)
    update!(token: token)
  end

  private

  def self.valid_password(password, password_confirmation)
    if password != password_confirmation
      raise InvalidParamError.new('パスワードが一致しません')
    end
  end

  def self.account_authenticate(user, params)
    if user.authenticate(params[:password])
      user
    else
      raise AuthenticationError.new(AuthenticationError::DEFAULT_MESSAGE)
    end
  end
end
