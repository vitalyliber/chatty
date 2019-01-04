class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

  def record_not_found(error)
    render json: {:error => error.message}, status: :not_found
  end

  def record_invalid(error)
    render json: {:error => error.message}, status: :bad_request
  end
end
