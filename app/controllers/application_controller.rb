class ApplicationController < ActionController::API
  rescue_from StandardError, with: :handler_error

  private

  def build_validation_error(record)
    @error = record.errors.full_messages.join(", ")
  end

  def handler_error(e)
    @error = e.message
    render "shared/error", status: :unprocessable_entity
  end
end
