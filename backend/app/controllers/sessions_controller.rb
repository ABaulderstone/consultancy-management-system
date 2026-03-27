class SessionsController < ApplicationController
  skip_forgery_protection only: :create
  skip_before_action :authenticate_user!, only: :create

  def show
    render json: UserBlueprint.render(Current.user)
  end


  def create
    user = User.find_by_email(session_params[:email])


    if user&.authenticate(session_params[:password])
      token = JwtService.encode(user_id: user.id)

      cookies.signed[:jwt] = {
        value: token,
        httponly: true,
        secure: Rails.env.production?,
        same_site: :lax
      }
      render json: UserBlueprint.render(user)
    else
      raise UnauthorizedError, "Invalid credentials"
    end
  end

  def destroy
    cookies.delete(:jwt)
    head :no_content
  end

  private
    def session_params
      params.permit(:email, :password)
    end
end
