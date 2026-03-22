class UserProfileBlueprint < Blueprinter::Base
  identifier :id
  fields :email, :role

  field :first_name do |user, _|
    user.profile&.first_name
  end

  field :last_name do |user, _|
    user.profile&.last_name
  end

  field :title do |user, _|
    user.profile&.title
  end

  field :gender do |user, _|
    user.profile&.gender
  end

  field :date_of_birth do |user, _|
    user.profile&.date_of_birth
  end

  field :employment_status do |user, _|
    if user.current_contract.present?
      'active'
    elsif user.contracts.any?
      'departed'
    else
      'uncontracted'
    end
  end

  field :assignment_status do |user, _|
    if user.current_contract.present? && user.current_contract.position&.department&.billable
      user.active_assignment.present? ? 'assigned' : 'bench'
    end
  end

  field :current_contract do |user, _|
    contract = user.current_contract
    next nil unless contract

    {
      contract_type: contract.contract_type,
      rate: contract.rate,
      payable_rate: contract.payable_rate,
      daily_cost: contract.daily_cost.round(2),
      fte: contract.fte,
      start_date: contract.start_date,
      position: {
        title: contract.position&.title,
        department: contract.position&.department&.name
      }
    }
  end

  field :current_job do |user, _|
    assignment = user.active_assignment
    next nil unless assignment

    job = assignment.job
    daily_cost = user.current_contract&.daily_cost || 0

    {
      title: job.title,
      client: job.client&.name,
      start_date: job.start_date,
      day_rate: job.day_rate,
      daily_margin: (job.day_rate - daily_cost).round(2)
    }
  end

  field :lifetime_utilisation do |user, _|
    Users::CalculateUtilisation.call(user: user)
  end
end