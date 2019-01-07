class ApplicationController < ActionController::Base
  include ApplicationHelper
  before_action :restrict_access
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

  def record_not_found(error)
    render json: {:error => error.message}, status: :not_found
  end

  def record_invalid(error)
    render json: {:error => error.message}, status: :bad_request
  end

  def restrict_access
    authenticate_or_request_with_http_token do |token, _options|
      if token.present?
        @current_user = auth(token)
        return @current_user.present?
      end
      false
    end
  end

  def current_user
    @current_user
  end
end
