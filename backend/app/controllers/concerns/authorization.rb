module Authorization
  extend ActiveSupport::Concern

  private

  def require_role(*roles)
    unless Current.user && roles.map(&:to_s).include?(Current.user.role)
      render json: { error: "Forbidden" }, status: :forbidden
    end
  end

  
  def only_admin
    require_role(:admin)
  end

  def only_employee
    require_role(:employee)
  end
end