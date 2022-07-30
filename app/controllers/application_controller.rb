class ApplicationController < ActionController::API
  include ErrorRenderable
  include ActionController::HttpAuthentication::Token::ControllerMethods
  before_action :authenticate_token

  def authenticate_token
    authenticate_or_request_with_http_token do |token, options|
      @current_user = User.find_by(token: token)
    end
  end
end
