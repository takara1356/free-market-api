class InvalidParamError < RuntimeError
  attr_accessor :detail

  def initialize(detail = nil)
    @detail = detail ? detail : 'Internal Server Error'
  end
end
