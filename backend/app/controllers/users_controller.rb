class UsersController < ApplicationController
  before_action :set_user, only: [ :show, :update, :destroy ]
  before_action :only_admin!, only: [ :destroy, :create, :index, :contracts, :assignments ]
  before_action :authorize_admin_or_self!, only: [ :show, :update ]



  def index
    allowed_sort_columns = {
    "first_name" => "profiles.first_name",
    "last_name" => "profiles.last_name",
    "email" => "users.email"
  }

    sort_column = allowed_sort_columns.include?(params[:sort]) ? params[:sort] : "users.id"
    sort_direction = %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"

    users = User
      .with_status_select
      .includes(:profile, :active_assignment, current_contract: { position: :department })
      .left_joins(:profile)

    users = users.where(role: params[:role]) if params[:role].present?

    users = case params[:employment_status]
    when "active" then users.merge(User.active_employees)
    when "departed" then users.merge(User.departed)
    when "uncontracted" then users.merge(User.uncontracted)
    else users
    end

    users = case params[:assignment_status]
    when "assigned" then users.merge(User.assigned)
    when "bench" then users.merge(User.on_bench)
    else users
    end

    users = users.order("#{sort_column} #{sort_direction}")
    paginated_response(users,  UserBlueprint)
  end


  def show
    render json: UserProfileBlueprint.render(@user)
  end

  def contracts
    user = User.find(params[:id])
    contracts = user.contracts.includes(position: :department).order(start_date: :desc)
    render json: ContractBlueprint.render(contracts)
  end

  def assignments
    user = User.find(params[:id])
    assignments = user.assignments
     .includes(job: :client)
     .order(start_date: :desc)
    render json: AssignmentBlueprint.render(assignments)
  end

  def create
    result = Users::CreateUser.call(params: user_params)
    render json: UserBlueprint.render(result[:user]), status: :created
  end


  def update
    user = Users::UpdateUser.call(user: @user, params: user_params)
    render json: UserBlueprint.render(user)
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
        @user = User.includes(
                  :profile,
                  :contracts,
                  :active_assignment,
                  current_contract: { position: :department },
                  active_assignment: { job: :client }
                ).find(params[:id])
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
