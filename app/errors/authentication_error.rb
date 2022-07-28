class AuthenticationError < RuntimeError
  attr_accessor :detail
  DEFAULT_MESSAGE = 'パスワードが一致していない、もしくはユーザーが存在しません'

  def initialize(detail = nil)
    @detail = detail ? detail : 'Internal Server Error'
  end
end
