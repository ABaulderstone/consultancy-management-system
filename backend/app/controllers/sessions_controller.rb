class SessionsController < ApplicationController
  skip_forgery_protection only: :create
  skip_before_action :authenticate_user!, only: :create

  def show
    render json: Current.user
  end


  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = JwtService.encode(user_id: user.id)

      cookies.signed[:jwt] = {
        value: token,
        httponly: true,
        secure: Rails.env.production?,
        same_site: :lax
      }

      render json: user
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end

  def destroy
    cookies.delete(:jwt)
    head :no_content
  end
end
