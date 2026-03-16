class UsersController < ApplicationController
  before_action :set_user, only: [ :show, :update, :destroy ]
  before_action :only_admin!, only: [ :destroy, :create, :index ]
  before_action :authorize_admin_or_self!, only: [ :show, :update ]



  def index
    allowed_sort_columns = %w[first_name last_name email]
    sort_column = allowed_sort_columns.include?(params[:sort]) ? params[:sort] : 'user.id'
    sort_direction = %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'

    users = User.left_joins(:profile).order("#{sort_column} #{sort_direction}")
    paginated_response(users, EnrichedUserBlueprint)
  end


  def show
    render json: EnrichedUserBlueprint.render(@user)
  end

  def create
    result = Users::CreateUser.call(params: user_params)
    render json: EnrichedUserBlueprint.render(result[:user]), status: :created
  end


  def update
    user = Users::UpdateUser.call(user: @user, params: user_params)
    render json: EnrichedUserBlueprint.render(user)
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
        params.permit(:first_name, :last_name, :date_of_birth, :gender, :title)
      end

      def authorize_admin_or_self!
        return if Current.user.admin?
        return if @user == Current.user

        raise ForbiddenError, "Forbidden action"
      end
end
