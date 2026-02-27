class UsersController < ApplicationController
  before_action :set_user, only: [ :show, :update, :destroy ]
  before_action :only_admin!, only: [ :destroy, :create, :index ]
  before_action :authorize_admin_or_self!, only: [ :show, :update ]



  def index
    users = User.includes(:profile).all
    paginated_response(users, EnrichedUserBlueprint)
  end


  def show
    render json: EnrichedUserBlueprint.render(@user)
  end

  def create
    user = User.create!(user_params)
    render json: UserBlueprint.render(user), status: :created
  end


  def update
    @user.update!(user_params)
    render json: EnrichedUserBlueprint.render(@user)
  end


  def destroy
    @user.destroy
    head :no_content
  end

  def current
    render json: EnrichedUserBlueprint.render(Current.user)
  end

    private

      def set_user
        @user = User.includes(:profile).find(params[:id])
      end

      def user_params
        permitted = [ :email, :password ]

        permitted << :role if Current.user.admin?

        params.require(:user).permit(permitted)
      end

      def authorize_admin_or_self!
        return if Current.user.admin?
        return if @user == Current.user

        raise ForbiddenError, "Forbidden action"
      end
end
