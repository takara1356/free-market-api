module ErrorRenderable
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError do |e|
      if ENV['RAILS_ENV'] != 'development'
        render status: 500, json: { error: { message: e.message } }
      else
        raise
      end
    end

    rescue_from InvalidParamError do |e|
      render status: 400, json: { error: { message: e.message } }
    end

    rescue_from ActiveRecord::RecordNotFound do |e|
      render status: 404, json: { error: { message: e.message } }
    end

    rescue_from AuthenticationError do |e|
      render status: 400, json: { error: { message: e.message } }
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      render status: 400, json: { error: { message: e.message } }
    end

    rescue_from InvalidOperationError do |e|
      render status: 400, json: { error: { message: e.message } }
    end
  end
end
