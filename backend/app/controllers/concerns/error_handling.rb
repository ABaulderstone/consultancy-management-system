module ErrorHandling
  extend ActiveSupport::Concern

  included do
    ERROR_STATUS_MAP = {
      ActiveRecord::RecordNotFound => :not_found,
      ActiveRecord::RecordNotUnique => :conflict,
      ForbiddenError => :forbidden,
      InvalidParamsError => :unprocessable_entity,
      UnauthorizedError => :unauthorized
    }.freeze

    ERROR_STATUS_MAP.each_key { |error_class| rescue_from error_class, with: :render_standard_error }
    rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid
  end

  private

    def render_standard_error(e)
      render_error ERROR_STATUS_MAP[e.class], e.message
    end

    def render_record_invalid(e)
      render_error :unprocessable_content, "Validation failed",
        errors: e.record.errors.group_by_attribute.transform_values { |errs| errs.map(&:message) }
    end

    def render_error(status, message, errors: nil)
      status_code = Rack::Utils.status_code(status)
      status_message = Rack::Utils::HTTP_STATUS_CODES[status_code]

      payload = {
        timestamp: Time.now.utc.iso8601,
        status: status_code,
        error: status_message,
        message: message,
        path: request.path
      }
      payload[:details] = errors if errors.present?
      render json: payload, status: status
    end
end