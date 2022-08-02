class InvalidParamError < RuntimeError
  attr_accessor :message

  def initialize(message = nil)
    @message = message ? message : 'Internal Server Error'
  end
end
