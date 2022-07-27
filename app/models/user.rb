class User < ApplicationRecord
  # TODO: パラメータのバリデーション
  has_secure_password

  RegistrationRewardPoint = 10000

  def self.create(params)
    valid_password(params[:password], params[:password_confirmation])
    # TODO: 例外処理の追加
    ApplicationRecord.transaction do
      user = create!(name: params[:name],
              email: params[:email],
              password: params[:password],
              password_confirmation: params[:password_confirmation],
              point: RegistrationRewardPoint)
      user
    end
  end

  private

  def self.valid_password(password, password_confirmation)
    if password != password_confirmation
      raise InvalidParamError.new('パスワードが一致しません')
    end
  end
end