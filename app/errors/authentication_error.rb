class AuthenticationError < RuntimeError
  attr_accessor :message
  DEFAULT_MESSAGE = 'パスワードが一致していない、もしくはユーザーが存在しません'

  def initialize(message = nil)
    @message = message ? message : 'Internal Server Error'
  end
end
