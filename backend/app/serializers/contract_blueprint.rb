class ContractBlueprint < Blueprinter::Base
  identifier :id
  fields :contract_type, :start_date, :end_date

  field :rate do |contract, _|
    contract.rate.to_f
  end

  field :fte do |contract, _|
    contract.fte&.to_f
  end

  field :payable_rate do |contract, _|
    contract.payable_rate.to_f
  end

  field :daily_cost do |contract, _|
    contract.daily_cost.to_f.round(2)
  end

  field :position do |contract, _|
    {
      title: contract.position&.title,
      department: contract.position&.department&.name
    }
  end
end
