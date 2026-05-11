class ContractsController < ApplicationController

  before_action :only_admin!, only: [ :create ]
  
  def create
    contract = Contracts::CreateContract.call(
      params: contract_params
    )

    render json:ContractBlueprint.render(contract), status: :created
  end

  private

  def contract_params
    params.permit(
      :user_id,
      :position_id,
      :contract_type,
      :fte,
      :rate,
      :start_date,
      :end_date
    )
  end
end