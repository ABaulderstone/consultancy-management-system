class UsersController < ApplicationController
  before_action :set_user, only: [ :show, :update, :destroy ]
  before_action :only_admin, only: [ :destroy, :create, :index ]
  before_action :authorize_admin_or_self!, only: [ :show, :update ]



  def index
    users = User.all
    paginated_response(users, UserBlueprint)
  end


  def show
    render json: UserBlueprint.render(@user)
  end

  def create
    user = User.new(user_params)

    if user.save
      render json: UserBlueprint.render(user), status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end


  def update
    if @user.update(user_params)
      render json: UserBlueprint.render(@user)
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end


  def destroy
    @user.destroy
    head :no_content
  end

  def current
    render json: UserBlueprint.render(Current.user)
  end

    private

      def set_user
        @user = User.find(params[:id])
      end

      def user_params
        permitted = [ :email, :password ]

        permitted << :role if Current.user.admin?

        params.require(:user).permit(permitted)
      end

      def authorize_admin_or_self!
        return if Current.user.admin?
        return if @user == Current.user

        render json: { error: "Forbidden" }, status: :forbidden
      end
end
