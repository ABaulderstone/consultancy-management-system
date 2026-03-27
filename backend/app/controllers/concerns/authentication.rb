module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
  end

  private

    def authenticate_user!
      token = extract_token
      return unauthorized! unless token

      payload = JwtService.decode(token)
      return unauthorized! unless payload

      user = User.find(payload["user_id"])

      Current.user = user
    end

    def extract_token
      bearer_token || cookie_token
    end

    def bearer_token
      header = request.headers["Authorization"]
      return nil unless header&.start_with?("Bearer ")

      header.split(" ").last
    end

    def cookie_token
      cookies.signed[:jwt]
    end

    def unauthorized!
      raise UnauthorizedError, "Unauthenticated"
    end
end
